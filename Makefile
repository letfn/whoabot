SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile | sort -b

check: # Check pre-requisites
	which make
	which perl
	which docker
	which drone
	which watchmedo

bootstrap: # Bootstrap pre-requisites
	python -m venv .venv
	source .venv/bin/activate && pip install watchdog[watchmedo]

all: # Reformat, Lint, Test, Validate
	$(MAKE) fmt
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) validateo

watch: # Watch for changes
	source .venv/bin/activate && watchmedo shell-command --ignore-directories --drop --patterns='*.py' --recursive --command 'figlet woke; make lint test' src

docs: # Build docs with hugo
	drone exec --pipeline docs

test: # Test with pytest, coverage
	drone exec --pipeline test

fmt: # Format with isort, black
	drone exec --pipeline fmt

lint: # Lint with pyflakes, mypy
	drone exec --pipeline lint

validate: # Validate CI config
	drone exec --pipeline validate

base: # Build the Docker base for running drone pipelines
	$(MAKE) ci-base
	$(MAKE) ci-base-push

ci-base:
	docker build -t defn/ubuntu:python .
	$(MAKE) ci-base-copy CID="$(shell docker create defn/ubuntu:python)"

ci-base-push:
	docker push defn/ubuntu:python

ci-base-copy:
	docker cp $(CID):/drone/src/requirements.txt . && docker cp $(CID):/drone/src/src/requirements.txt src/ && docker rm -f $(CID)

