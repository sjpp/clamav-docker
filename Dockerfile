FROM debian:bookworm-slim

LABEL maintainer="Sébastien Poher <sebastien.poher@probesys.coop>"
LABEL name="ClamAV dockerized for AgentJ SaaS"
LABEL description="Starts local ClamAV as remote TCP AV scanner"

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lib,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,id=debconf,target=/var/cache/debconf,sharing=locked \
    apt-get update -q --fix-missing && \
    apt-get -y install --no-install-recommends \
    arj \
    bzip2 \
    ca-certificates \
    cabextract \
    clamav >=1.0.7+dfsg-1~deb12u1 \
    clamav-daemon>=1.0.7+dfsg-1~deb12u1 \
    clamav-base>=1.0.7+dfsg-1~deb12u1 \
    clamav-freshclam>=1.0.7+dfsg-1~deb12u1 \
    clamav-milter>=1.0.7+dfsg-1~deb12u1 \
    cpio \
    cron \
    file \
    gpg-agent \
    gzip \
    iproute2 \
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
USER root
ENTRYPOINT [ "/entrypoint.sh" ]
HEALTHCHECK --start-period=60s CMD [ "/healthcheck.sh" ]
