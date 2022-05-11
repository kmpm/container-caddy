all: gen-dockerfiles


gen-dockerfiles: render-dockerfiles.tmpl Dockerfile.tmpl Dockerfile.builder.tmpl */*/Dockerfile.base
	@gomplate \
		-t dockerfile=Dockerfile.tmpl \
		-t builder-dockerfile=Dockerfile.builder.tmpl \
		-c config=./config.yaml \
		-f $<

container:
	docker build -f 2.5/alpine/Dockerfile ./ctx

.PHONY: all gen-dockerfiles container
.DELETE_ON_ERROR:
.SECONDARY:
