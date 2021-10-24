SHELL := /bin/bash

first = $(word 1, $(subst _, ,$@))
second = $(word 2, $(subst _, ,$@))

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

default:
	git add -u .
	-pc
	git add -u .
	pc

warm:
	docker pull "$(shell cat params.yaml | yq -r .base_upstream_source)"
	docker tag "$(shell cat params.yaml | yq -r .base_upstream_source)" "$(shell cat params.yaml | yq -r .base_source)"
	docker push $(shell cat params.yaml | yq -r .base_source)

build:
	$(MAKE) build_base
	$(MAKE) build_{app,ci}
	$(MAKE) build_{aws,terraform,cdktf}

build_%:
	argo submit --log -f params.yaml --entrypoint build-$(second) argo.yaml
