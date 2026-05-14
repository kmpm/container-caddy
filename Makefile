
TEMPLATES = render-dockerfiles.tmpl $(wildcard templates/*.tmpl)

all: gen


gen: $(TEMPLATES) */*/Dockerfile.base
	@gomplate \
		-t dockerfile=templates/Dockerfile.tmpl \
		-t builder-dockerfile=templates/Dockerfile.builder.tmpl \
		-t buildfile=templates/docker-build.sh.tmpl \
		-t publishfile=templates/docker-publish.sh.tmpl \
		-c config=./config.yaml \
		-f $<

build:
	./docker-build.sh

push:
	./docker-publish.sh

smoketest:
	docker run --rm -it -p 127.0.0.1:8085:80 kmpm/caddy:latest

.PHONY: all gen build push smoketest
.DELETE_ON_ERROR:
.SECONDARY:
