#!/bin/bash


CADDY_CONFIG=${CADDY_CONFIG:-/etc/caddy/Caddyfile}
CADDY_ADAPTER=${CADDY_ADAPETER:-caddyfile}


# function reload()
# {
#    caddy reload --config $CADDY_CONFIG --adapter $CADDY_ADAPTER
# }

#trap reload SIGUSR1


if [ "$1" = "caddy" ]; then
    exec "caddy run --config $CADDY_CONFIG --adapter $CADDY_ADAPTER"
fi

exec "$@"
