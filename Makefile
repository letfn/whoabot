SHELL := /bin/bash

.PHONY: cutout

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

build: # Build letfn/python
	docker build -t letfn/python .
	kiki style
	kiki test
	docker push letfn/python

cutout:
	rm -rf cutout
	cookiecutter --no-input --directory t/python gh:defn/cutouts \
		organization="Cuong Chi Nghiem" \
		project_name="letfn/python" \
		repo="letfn/python" \
		repo_cache="defn/cache"
	rsync -ia cutout/. .
	rm -rf cutout
	git difftool --tool=vimdiff -y
