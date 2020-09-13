SHELL := /bin/bash

test: # Test letfn/python image
	echo "TEST_PY=$(shell cat test.py | base64 -w 0)" > .drone.env
	drone exec --env-file=.drone.env --pipeline test

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

build: # Build letfn/python
	@echo
	docker build -t letfn/python .
	$(MAKE) test

push: # Push letfn/python
	docker push letfn/python

bash: # Run bash shell with letfn/python
	docker run --rm -ti --entrypoint bash letfn/python
