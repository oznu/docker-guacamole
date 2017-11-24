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

* auth-ldap - [LDAP Authentication](https://guacamole.incubator.apache.org/doc/0.9.13-incubating/gug/ldap-auth.html)
* auth-duo - [Duo two-factor authentication](https://guacamole.incubator.apache.org/doc/0.9.13-incubating/gug/duo-auth.html)
* auth-header - [HTTP header authentication](https://guacamole.incubator.apache.org/doc/0.9.13-incubating/gug/header-auth.html)
* auth-cas - [CAS Authentication](https://guacamole.incubator.apache.org/doc/0.9.13-incubating/gug/cas-auth.html)

You should only enable the extensions you require, if an extensions is not configured correctly in the `guacamole.properties` file it may prevent the system from loading. See the [official documentation](https://guacamole.incubator.apache.org/doc/0.9.13-incubating/gug/) for more details.

## Default User

The default username is `guacadmin` with password `guacadmin`.
