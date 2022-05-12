all: gen-dockerfiles


gen-dockerfiles: render-dockerfiles.tmpl Dockerfile.tmpl Dockerfile.builder.tmpl */*/Dockerfile.base
	@gomplate \
		-t dockerfile=Dockerfile.tmpl \
		-t builder-dockerfile=Dockerfile.builder.tmpl \
		-c config=./config.yaml \
		-f $<

container:
	docker build --progress plain -f 2.5/alpine/Dockerfile -t kmpm/caddy:2.5 -t kmpm/caddy:2.5.1-alpine -t kmpm/caddy:alpine -t kmpm/caddy:latest ./ctx

push:
	docker push --all-tags kmpm/caddy

.PHONY: all gen-dockerfiles container
.DELETE_ON_ERROR:
.SECONDARY:
