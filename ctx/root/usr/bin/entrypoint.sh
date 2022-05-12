#!/bin/sh


CADDY_CONFIG=${CADDY_CONFIG:-/etc/caddy/Caddyfile}
CADDY_ADAPTER=${CADDY_ADAPETER:-caddyfile}


echo CADDY_CONFIG=$CADDY_CONFIG
echo CADDY_ADAPTER=$CADDY_ADAPTER
echo PWD=$(pwd)


if [ "$1" = "caddy" ]; then
    exec caddy run --watch --config $CADDY_CONFIG --adapter $CADDY_ADAPTER
fi

exec "$@"
