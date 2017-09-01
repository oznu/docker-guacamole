# Docker Guacamole

A Docker Container for [Apache Guacamole](https://guacamole.incubator.apache.org/), a clientless remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH over HTML5.
  
[![IMAGE ALT TEXT](http://img.youtube.com/vi/esgaHNRxdhY/0.jpg)](http://www.youtube.com/watch?v=esgaHNRxdhY "Video Title")

This container runs the guacamole web client, the guacd server and a postgres database.

## Usage

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  oznu/guacamole
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `-p 8080:8080` - Binds the service to port 8080 on the Docker host, **required**
* `-v /config` - The config and database location, **required**

## Default User

The default username is `guacadmin` with password `guacadmin`.
