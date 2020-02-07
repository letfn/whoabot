SHELL := /bin/bash

ifeq (update,$(firstword $(MAKECMDGOALS)))
UPDATES := $(strip $(wordlist 2,100,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(UPDATES):;@:)
endif

ifeq (update-nnn,$(firstword $(MAKECMDGOALS)))
UPDATES := $(strip $(wordlist 2,100,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(UPDATES):;@:)
endif

all: # Reformat, Lint, Test, Validate
	$(MAKE) fmt
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) validate

menu:
	@perl -ne 'printf("%15s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile | sort -b

ci-base:
	docker build -t defn/ubuntu:python .
	$(MAKE) ci-base-copy CID="$(shell docker create defn/ubuntu:python)"

ci-base-push:
	docker push defn/ubuntu:python

ci-base-copy:
	docker cp $(CID):/drone/src/requirements.txt . && docker cp $(CID):/drone/src/src/requirements.txt src/ && docker rm -f $(CID)

docs:
	drone exec --pipeline docs

watch:
	drone exec --pipeline watch

test:
	drone exec --pipeline test

fmt:
	drone exec --pipeline fmt

lint:
	drone exec --pipeline lint

validate:
	drone exec --pipeline validate

ci-fmt: # Format with isort, black
	source /drone/venv/bin/activate && isort $(shell git ls-files src | grep 'py$$')
	source /drone/venv/bin/activate && black src

ci-lint: # Lint with mypy, pyflakes
	source /drone/venv/bin/activate && mypy src
	source /drone/venv/bin/activate && pyflakes src

ci-test: # Test with pytest, coverage
	source /drone/venv/bin/activate && pytest -v --cov=main --cov-report=term-missing src
