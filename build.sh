#!/bin/env bash
set -e

DO_PUBLISH=$1

function build() {
	docker build --file 2.11/alpine/Dockerfile \
	--tag kmpm/caddy:latest \
	--tag kmpm/caddy:2.11.2 \
	--tag kmpm/caddy:2.11 \
	--tag ghcr.io/kmpm/container-caddy/caddy:latest \
	--tag ghcr.io/kmpm/container-caddy/caddy:2.11.2 \
	--tag ghcr.io/kmpm/container-caddy/caddy:2.11 \
	./ctx
}


function publish() {
	if [ ! -z "$DOCKERHUB_TOKEN" ]; then
		echo "Logging in to Docker registry for kmpm/caddy..."
		echo "$DOCKERHUB_TOKEN" | docker login --username $DOCKERHUB_USER --password-stdin $(echo kmpm/caddy | cut -d'/' -f1)
		set -x
		docker push kmpm/caddy:latest
		docker push kmpm/caddy:2.11.2
		docker push kmpm/caddy:2.11
		set +x
	fi
	if [ ! -z "$GITHUB_TOKEN" ]; then
		echo "Logging in to Docker registry for ghcr.io/kmpm/container-caddy/caddy..."
		echo "$GITHUB_TOKEN" | docker login --username $GITHUB_USER --password-stdin $(echo ghcr.io/kmpm/container-caddy/caddy | cut -d'/' -f1)
		set -x
		docker push ghcr.io/kmpm/container-caddy/caddy:latest
		docker push ghcr.io/kmpm/container-caddy/caddy:2.11.2
		docker push ghcr.io/kmpm/container-caddy/caddy:2.11
		set +x
	fi
}


build
if [ "$DO_PUBLISH" == "publish" ]; then
  publish
fi
