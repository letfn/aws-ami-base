SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile | sort -b

all: # Run everything except build
	$(MAKE) fmt
	$(MAKE) lint
	$(MAKE) docs
	$(MAKE) test

fmt: # Format drone fmt
	@echo
	drone exec --pipeline $@

lint: # Run drone lint
	@echo
	drone exec --pipeline $@

test: # Run tests
	@echo
	drone exec --pipeline $@

docs: # Build docs
	@echo
	drone exec --pipeline $@

build: # Build AMI
	@echo
	aws-okta env d-hub | sed 's#^export ##' > .drone.env
	drone exec --pipeline $@ --env-file .drone.env

packer:
	env \
    DEFN_PACKER_FILTERS_NAME="amzn2-ami-ecs-hvm-*" \
    DEFN_PACKER_AMI_NAME="defn-bare-$(shell date +%s)" \
      packer build -timestamp-ui=true packer.json
