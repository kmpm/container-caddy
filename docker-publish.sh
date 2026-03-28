#!/bin/env bash
set -e


function publish() {
	if [ ! -z "$DOCKER_TOKEN" ]; then
		# echo "Logging in to Docker registry for kmpm/caddy..."
		# echo "$DOCKER_TOKEN" | docker login --username $DOCKER_USER --password-stdin $(echo kmpm/caddy | cut -d'/' -f1)
		set -x
		docker push kmpm/caddy:latest
		docker push kmpm/caddy:2.11.2
		docker push kmpm/caddy:2.11
		set +x
	fi
	if [ ! -z "$GITHUB_TOKEN" ]; then
		# echo "Logging in to Docker registry for ghcr.io/kmpm/caddy..."
		# echo "$GITHUB_TOKEN" | docker login --username $GITHUB_USER --password-stdin $(echo ghcr.io/kmpm/caddy | cut -d'/' -f1)
		set -x
		docker push ghcr.io/kmpm/caddy:latest
		docker push ghcr.io/kmpm/caddy:2.11.2
		docker push ghcr.io/kmpm/caddy:2.11
		set +x
	fi
}

publish
