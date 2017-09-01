# Docker Guacamole

A Docker Container for [Apache Guacamole](https://guacamole.incubator.apache.org/), a client-less remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH over HTML5.

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
