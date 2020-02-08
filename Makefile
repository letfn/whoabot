SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile | sort -b

check: # Check pre-requisites
	which make
	which perl
	which docker
	which drone
	which fswatch

bootstrap: # Bootstrap pre-requisites
	$(MAKE) bootstrap_$(shell uname -s)
	$(MAKE) check

bootstrap_Darwin:
	brew install fswatch
	curl -sSL -O https://github.com/drone/drone-cli/releases/download/v1.2.1/drone_darwin_amd64.tar.gz
	tar xvfz drone_darwin_amd64.tar.gz
	rm -f drone_darwin_amd64.tar.gz
	chmod 755 drone
	mv drone /usr/local/bin/

all: # Reformat, Lint, Test, Validate
	$(MAKE) fmt
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) validate
	$(MAKE) docs

watch: # Watch for changes
	@trap 'exit' INT; while true; do fswatch -0 src content | while read -d "" event; do case "$$event" in *.py) figlet woke; make lint test; break; ;; *.md) figlet docs; make docs; ;; esac; done; sleep 1; done

docs: # Build docs with hugo
	@echo
	drone exec --pipeline docs

test: # Test with pytest, coverage
	@echo
	drone exec --pipeline test

fmt: # Format with isort, black
	@echo
	drone exec --pipeline fmt

lint: # Lint with pyflakes, mypy
	@echo
	drone exec --pipeline lint

validate: # Validate CI config
	@echo
	drone exec --pipeline validate

build : # Build the Docker base for running drone pipelines
	@echo
	drone exec --pipeline build --secret-file .drone.secret

pull:
	docker pull defn/python

warm:
	docker run -v $(PWD)/.kaniko.cache:/cache gcr.io/kaniko-project/warmer:latest --verbosity=debug --image=python:3.8.1-buster
