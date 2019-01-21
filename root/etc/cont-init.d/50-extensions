#!/usr/bin/with-contenv sh

# clean up extensions
for i in auth-ldap auth-duo auth-header auth-cas auth-openid auth-quickconnect auth-totp; do
  rm -rf ${GUACAMOLE_HOME}/extensions/guacamole-${i}-${GUAC_VER}.jar
done

# if the guacamole version was bumped, delete the contents of the extensions directory - just on the first run 
if [ "$(cat /config/.database-version)" != "$GUAC_VER" ]; then
  rm -rf ${GUACAMOLE_HOME}/extensions/*
fi

# enable extensions
for i in $(echo "$EXTENSIONS" | tr "," " "); do
  cp ${GUACAMOLE_HOME}/extensions-available/guacamole-${i}-${GUAC_VER}.jar ${GUACAMOLE_HOME}/extensions
done
