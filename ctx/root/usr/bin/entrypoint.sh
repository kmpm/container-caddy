#!/bin/sh
set -e


CADDY_CONFIG=${CADDY_CONFIG:-/etc/caddy/Caddyfile}
CADDY_ADAPTER=${CADDY_ADAPETER:-caddyfile}


echo CADDY_CONFIG=$CADDY_CONFIG
echo CADDY_ADAPTER=$CADDY_ADAPTER
echo PWD=$(pwd)

# if first arg looks like a flag, assume we want to run caddy server
if [ "${1:0:1}" = '-' ]; then
    set -- caddy "$@"
fi

if [ "$1" = "caddy" ]; then
    echo "Running caddy..:"
    # if no flags are provided, run caddy with our default flags
    if [ "$#" -eq 1 ]; then
        echo "No additional flags provided, running caddy with default flags"
        set -- caddy run --watch --config $CADDY_CONFIG --adapter $CADDY_ADAPTER
    fi

    exec "$@"
fi

exec "$@"
