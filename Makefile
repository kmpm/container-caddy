
TEMPLATES = render-dockerfiles.tmpl $(wildcard templates/*.tmpl)

all: gen


gen: $(TEMPLATES) */*/Dockerfile.base
	@gomplate \
		-t dockerfile=templates/Dockerfile.tmpl \
		-t builder-dockerfile=templates/Dockerfile.builder.tmpl \
		-t buildfile=templates/buildfile.sh.tmpl \
		-c config=./config.yaml \
		-f $<

build:

	./build.sh

push:
	docker push --all-tags kmpm/caddy

.PHONY: all gen build push
.DELETE_ON_ERROR:
.SECONDARY:
