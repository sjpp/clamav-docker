FROM alpine:3.17

LABEL maintainer = "Sébastien Poher <sebastien.poher@probesys.com>"
LABEL name = "ClamAV dockerized for AgentJ SaaS"
LABEL description = "Starts local ClamAV as remote TCP AV scanner"

RUN apk --no-cache add \
    unarj \
    bzip2 \
    ca-certificates \
    cabextract \
    clamav \
    clamav-clamdscan \
    clamav-db \
    clamav-daemon \
    clamav-libunrar \
    clamav-milter \
    clamav-scanner \
    cpio \
    dcron \
    file \
    freshclam \
    gpg-agent \
    gzip \
    perl-dbd-mysql \
    perl-db \
    perl-dbi \
    perl-io-socket-ssl \
    perl-mail-spf \
    patch \
    pax-utils \
    rsyslog \
    supervisor \
    tzdata \
    unzip \
    zip

COPY conf/supervisor/supervisord.conf /etc/supervisord.conf
COPY conf/clamav/clamd.conf /etc/clamav/clamd.conf
COPY conf/cron/freshclam /etc/cron.d/freshclam
COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh

RUN /usr/bin/freshclam --log=/var/log/clamav/freshclam.log \
        --daemon-notify=/etc/clamav/clamd.conf \
        --config-file=/etc/clamav/freshclam.conf

EXPOSE 3310/tcp

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
ENTRYPOINT [ "/entrypoint.sh" ]
HEALTHCHECK --start-period=60s CMD [ "/healthcheck.sh" ]