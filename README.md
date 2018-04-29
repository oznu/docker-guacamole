[![Docker Build Status](https://img.shields.io/docker/build/oznu/guacamole.svg?label=x64%20build&style=for-the-badge)](https://hub.docker.com/r/oznu/guacamole/) [![Travis](https://img.shields.io/travis/oznu/docker-guacamole.svg?label=arm%20build&style=for-the-badge)](https://travis-ci.org/oznu/docker-guacamole) [![Docker Pulls](https://img.shields.io/docker/pulls/oznu/guacamole.svg?style=for-the-badge)](https://hub.docker.com/r/oznu/guacamole/)

# Docker Guacamole

A Docker Container for [Apache Guacamole](https://guacamole.incubator.apache.org/), a client-less remote desktop gateway. It supports standard protocols like VNC, RDP, and SSH over HTML5.

This image will run on most platforms that support Docker including Docker for Mac, Docker for Windows, Synology DSM and Raspberry Pi 2/3 boards.

[![IMAGE ALT TEXT](http://img.youtube.com/vi/esgaHNRxdhY/0.jpg)](http://www.youtube.com/watch?v=esgaHNRxdhY "Video Title")

This container runs the guacamole web client, the guacd server and a postgres database.

## Usage

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  oznu/guacamole
```

## Raspberry Pi / ARMv6

This image will also allow you to run [Apache Guacamole](https://guacamole.incubator.apache.org/) on a Raspberry Pi or other Docker-enabled ARMv5/6/7/8 devices by using the `armhf` tag.

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  oznu/guacamole:armhf
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `-p 8080:8080` - Binds the service to port 8080 on the Docker host, **required**
* `-v /config` - The config and database location, **required**
* `-e EXTENSIONS` - See below for details.

## Enabling Extensions

Extensions can be enabled using the `-e EXTENSIONS` variable. Multiple extensions can be enabled using a comma separated list without spaces.

For example:

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  -e "EXTENSIONS=auth-ldap,auth-duo"
  oznu/guacamole
```

Currently the available extensions are:

* auth-ldap - [LDAP Authentication](https://guacamole.incubator.apache.org/doc/0.9.14/gug/ldap-auth.html)
* auth-duo - [Duo two-factor authentication](https://guacamole.incubator.apache.org/doc/0.9.14/gug/duo-auth.html)
* auth-header - [HTTP header authentication](https://guacamole.incubator.apache.org/doc/0.9.14/gug/header-auth.html)
* auth-cas - [CAS Authentication](https://guacamole.incubator.apache.org/doc/0.9.14/gug/cas-auth.html)
* auth-openid - [OpenID Connect authentication](http://guacamole.apache.org/doc/0.9.14/gug/openid-auth.html)

You should only enable the extensions you require, if an extensions is not configured correctly in the `guacamole.properties` file it may prevent the system from loading. See the [official documentation](https://guacamole.incubator.apache.org/doc/0.9.13-incubating/gug/) for more details.

## Default User

The default username is `guacadmin` with password `guacadmin`.

## On Windows
Docker host drive mounts dont work properly on windows. To use postgress you must mount the config directoy inside of the docker vm. This uses a local driver to do this, be careful to gracefully shutdown or data will be lost, docker-compose:

```
version: "3.5"

services:
  guacamole:
    image: oznu/guacamole
    container_name: guacamole
    volumes:
      - postgres:/config
    ports:
      - 8080:8080
    network_mode: "bridge"

volumes:
  postgres:
    driver: local
```
