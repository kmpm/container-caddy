#!/bin/env bash
set -e


function build() {
	docker build --file 2.11/alpine/Dockerfile \
	--tag kmpm/caddy:latest \
	--tag kmpm/caddy:2.11.3 \
	--tag kmpm/caddy:2.11 \
	--tag ghcr.io/kmpm/caddy:latest \
	--tag ghcr.io/kmpm/caddy:2.11.3 \
	--tag ghcr.io/kmpm/caddy:2.11 \
	./ctx
}


build
