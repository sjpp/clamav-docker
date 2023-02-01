# ClamAV Docker image

## Usage

This repo provides a ClamAV image, to use it:

```
cp .env.example .env
# Edit .env variables if necessary, see below
docker-compose up -d
```

ClamAV will start and listen on the IP address set in `CLAMAV_TCPADDRESS` and port set in `CLAMAV_TCPPORT` in `.env` file.

## Logging

* *clamd* will log its activity in `/var/log/clamav.log` and `/var/log/messages`
* *freshclam* will log database updates in `/var/log/clamav/freshclam.log`