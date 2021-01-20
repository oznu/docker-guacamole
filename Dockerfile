FROM tomcat:jdk15-openjdk-slim-buster

ENV ARCH=aarch64 \
GUAC_VER=1.3.0 \
GUACAMOLE_HOME=/app/guacamole \
PG_MAJOR=11 \
PGDATA=/config/postgres \
POSTGRES_USER=guacamole \
POSTGRES_DB=guacamole_db

#Add essential packages
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y curl apt-utils postgresql ghostscript

# Apply the s6-overlay

RUN curl -SLO "https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-${ARCH}.tar.gz" \
  && tar -xzf s6-overlay-${ARCH}.tar.gz -C / \
  && tar -xzf s6-overlay-${ARCH}.tar.gz -C /usr ./bin \
  && rm -rf s6-overlay-${ARCH}.tar.gz \
  && mkdir -p ${GUACAMOLE_HOME} \
    ${GUACAMOLE_HOME}/lib \
    ${GUACAMOLE_HOME}/extensions

WORKDIR ${GUACAMOLE_HOME}

# Look for debian testing packets
#RUN touch /etc/apt/apt.conf.d/00default \
  #&& echo $'APT::Default-Release "buster";' >> /etc/apt/apt.conf.d/00default \
  #&& touch /etc/apt/preferences.d/00default \
  #&& echo $'Package: * Pin: release n=buster Pin-Priority: 999\nPackage: * Pin: release n=bullseye Pin-Priority: 650\nPackage: freerdp2-dev libfreerdp-client2-2 Pin>
  #&& echo "deb http://deb.debian.org/debian bullseye main" >>  /etc/apt/sources.list \
  #&& echo "deb http://security.debian.org bullseye-security main" >>  /etc/apt/sources.list \
RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get -t buster-backports install -y \
    build-essential \
    libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin libossp-uuid-dev \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev \
    libpango1.0-dev freerdp2-dev libfreerdp-client2-2 \
    libssh2-1-dev libtelnet-dev libvncserver-dev libwebsockets-dev \
    libpulse-dev libssl-dev libvorbis-dev libwebp-dev \
  && apt-get autoremove && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

# Link FreeRDP to where guac expects it to be
RUN [ "$ARCH" = "aarch64" ] && ln -s /usr/local/lib/freerdp /usr/lib/${ARCH}-linux-gnu/freerdp || exit 0

# Install guacamole-server
RUN curl -SLO "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/source/guacamole-server-${GUAC_VER}.tar.gz" \
  && tar -xzf guacamole-server-${GUAC_VER}.tar.gz \
  && cd guacamole-server-${GUAC_VER} \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && cd .. \
  && rm -rf guacamole-server-${GUAC_VER}.tar.gz guacamole-server-${GUAC_VER} \
  && ldconfig

# Install guacamole-client and postgres auth adapter
RUN set -x \
  && rm -rf ${CATALINA_HOME}/webapps/ROOT \
  && curl -SLo ${CATALINA_HOME}/webapps/ROOT.war "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/binary/guacamole-${GUAC_VER}.war" \
  && curl -SLo ${GUACAMOLE_HOME}/lib/postgresql-42.1.4.jar "https://jdbc.postgresql.org/download/postgresql-42.1.4.jar" \
  && curl -SLO "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/binary/guacamole-auth-jdbc-${GUAC_VER}.tar.gz" \
  && tar -xzf guacamole-auth-jdbc-${GUAC_VER}.tar.gz \
  && cp -R guacamole-auth-jdbc-${GUAC_VER}/postgresql/guacamole-auth-jdbc-postgresql-${GUAC_VER}.jar ${GUACAMOLE_HOME}/extensions/ \
  && cp -R guacamole-auth-jdbc-${GUAC_VER}/postgresql/schema ${GUACAMOLE_HOME}/ \
  && rm -rf guacamole-auth-jdbc-${GUAC_VER} guacamole-auth-jdbc-${GUAC_VER}.tar.gz

# Add optional extensions
RUN set -xe \
  && mkdir ${GUACAMOLE_HOME}/extensions-available \
  && for i in auth-ldap auth-duo auth-header auth-cas auth-openid auth-quickconnect auth-totp; do \
    echo "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/binary/guacamole-${i}-${GUAC_VER}.tar.gz" \
    && curl -SLO "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/binary/guacamole-${i}-${GUAC_VER}.tar.gz" \
    && tar -xzf guacamole-${i}-${GUAC_VER}.tar.gz \
    && cp guacamole-${i}-${GUAC_VER}/guacamole-${i}-${GUAC_VER}.jar ${GUACAMOLE_HOME}/extensions-available/ \
    && rm -rf guacamole-${i}-${GUAC_VER} guacamole-${i}-${GUAC_VER}.tar.gz \
  ;done

ENV PATH=/usr/lib/postgresql/${PG_MAJOR}/bin:$PATH
ENV GUACAMOLE_HOME=/config/guacamole

WORKDIR /config

COPY root /

ENTRYPOINT [ "/init" ]
