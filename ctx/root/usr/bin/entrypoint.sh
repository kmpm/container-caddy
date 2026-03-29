#!/bin/sh
set -e

echo "Starting Caddy container entrypoint script"
echo "See https://github.com/kmpm/container-caddy for documentation and support"

CADDY_CONFIG=${CADDY_CONFIG:-/etc/caddy/Caddyfile}
CADDY_ENVFILE=${CADDY_ENVFILE:-/etc/caddy/env}
CADDY_ADAPTER=${CADDY_ADAPTER:-caddyfile}
CADDY_USER=${CADDY_USER:-caddy}
CADDY_GROUP=${CADDY_GROUP:-caddy}
CADDY_FMT=${CADDY_FMT:-False}
CADDY_GID=${CADDY_GID:-1000}
CADDY_UID=${CADDY_UID:-1000}


echo PWD=$(pwd)
echo XDG_DATA_HOME=$XDG_DATA_HOME
echo XDG_CONFIG_HOME=$XDG_CONFIG_HOME
echo CADDY_CONFIG=$CADDY_CONFIG
echo CADDY_ENVFILE=$CADDY_ENVFILE
echo CADDY_ADAPTER=$CADDY_ADAPTER
echo CADDY_USER=$CADDY_USER
echo CADDY_GROUP=$CADDY_GROUP
echo CADDY_FMT=$CADDY_FMT
echo CADDY_GID=$CADDY_GID
echo CADDY_UID=$CADDY_UID


function set_permissions() {
    #if CADDY_USER is root then do nothing
    if [ "$CADDY_USER" = "root" ]; then
        echo "CADDY_USER is root, skipping permission changes"
        return
    fi

    # get group of given CADDY_GID, if it exists
    if getent group $CADDY_GID > /dev/null 2>&1; then
        EXISTING_GROUP=$(getent group $CADDY_GID | cut -d: -f1)
        echo "GID $CADDY_GID already exists for group $EXISTING_GROUP, using existing group"
        CADDY_GROUP=$EXISTING_GROUP
    else
        echo "GID $CADDY_GID does not exist, creating group $CADDY_GROUP with GID $CADDY_GID"
        addgroup -S -g $CADDY_GID $CADDY_GROUP
    fi

    echo "Creating user $CADDY_USER with UID $CADDY_UID and GID $CADDY_GID"
    adduser -h /var/lib/$CADDY_USER -S -G $CADDY_GROUP -u $CADDY_UID $CADDY_USER

    echo "Setting permissions for $CADDY_USER on /var/lib/$CADDY_USER"
    chown -R $CADDY_USER:$CADDY_GROUP /var/lib/$CADDY_USER

    if [ -n "$XDG_DATA_HOME" ]; then
        echo "Setting permissions for $CADDY_USER on XDG_DATA_HOME: $XDG_DATA_HOME"
        chown -R $CADDY_USER:$CADDY_GROUP $XDG_DATA_HOME
    fi
    if [ -n "$XDG_CONFIG_HOME" ]; then
        echo "Setting permissions for $CADDY_USER on XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
        chown -R $CADDY_USER:$CADDY_GROUP $XDG_CONFIG_HOME
    fi

    echo "You have to make sure that the CADDY_USER has permissions to read the Caddyfile and any other files it needs to access"
}

function format_caddyfile() {
    # if CADDY_FMT is set to True and CADDY_ADAPTER is caddyfile, format the Caddyfile with caddy fmt
    if [ "$CADDY_FMT" = "True" ] && [ "$CADDY_ADAPTER" = "caddyfile" ]; then
        echo "Formatting Caddyfile with caddy fmt"
        caddy fmt --config $CADDY_CONFIG --overwrite
    else
        echo "Skipping Caddyfile formatting"
    fi
}

function show_tree() {
    local CADDY_CONFIG_DIR=$(dirname "$CADDY_CONFIG")
    echo "Showing tree of CADDY_CONFIG_DIR: $CADDY_CONFIG_DIR"
    tree $CADDY_CONFIG_DIR
}

# if first arg looks like a flag, assume we want to run caddy server
if [ "${1:0:1}" = '-' ]; then
    set -- caddy "$@"
fi

if [ "$1" = "caddy" ]; then
    set_permissions
    format_caddyfile
    # if no flags are provided, run caddy with our default flags
    if [ "$#" -eq 1 ]; then
        echo "No additional flags provided, running caddy with default flags"
        show_tree
        set -- caddy run --config $CADDY_CONFIG --adapter $CADDY_ADAPTER
        # if CADDY_ENVFILE exists, add --envfile flag
        if [ -f "$CADDY_ENVFILE" ]; then
            set -- "$@" --envfile "$CADDY_ENVFILE"
        fi
    fi

    echo "Running caddy..: $@"
    #run caddy as CADDY_USER
    exec gosu $CADDY_USER "$@"
fi

exec "$@"
