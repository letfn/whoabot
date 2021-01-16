SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

build: # Build defn/python
	@echo
	docker build -t defn/python $(build) .

test: # Test defn/python image
	echo "TEST_PY=$(shell cat test.py | (base64 -w 0 || base64) )" > .drone.env
	drone exec --env-file=.drone.env --pipeline test

push: # Push defn/python
	docker push defn/python

bash: # Run bash shell with defn/python
	docker run --rm -ti --entrypoint bash defn/python
