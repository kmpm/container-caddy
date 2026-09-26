FROM golang:1.26-alpine AS builder

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION=v0.4.7
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION=v2.11.4
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP=1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='99fd895a7b7799b18c43ea0915777d8701aaab2a010035b23495c28b4ae429edccd70adb9a01106180f8d9333d9b5df41e74f9702ce0e1cffcf8840698a9ab93' ;; \
		aarch64) binArch='arm64'; checksum='b4d52ad6db4184fa5366ef225d24b8340a47fc1924d250b329d3b95f416a0b14e16d72cf71f04f57046e8a26bad2b697ac14c833fc5f5607b9e1c838b9898520' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.4.7/xcaddy_0.4.7_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

WORKDIR /usr/bin

RUN xcaddy build \
	--with github.com/caddy-dns/loopia\
	--with github.com/caddy-dns/glesys

# end builder

# start container
# alpine/Dockerfile.base
FROM alpine:3.23

RUN apk --no-cache add ca-certificates nss-tools mailcap gosu curl wget \
	&& update-ca-certificates \
    && rm -rf /var/cache/apk/*

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy

COPY --from=builder /usr/bin/caddy /usr/bin/

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/docker-library/golang/blob/1eb096131592bcbc90aa3b97471811c798a93573/1.14/alpine3.12/Dockerfile#L9
RUN test -e /etc/nsswitch.conf || echo 'hosts: files dns' > /etc/nsswitch.conf

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.4
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/kmpm/container-caddy"

COPY /root /
RUN chmod 0755 /usr/bin/entrypoint.sh

EXPOSE 80
EXPOSE 443
EXPOSE 2019

WORKDIR /srv/

ENTRYPOINT ["entrypoint.sh"]

CMD ["caddy"]
