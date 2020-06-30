# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CURRENT_OS := $(shell uname -s)
ifeq ($(CURRENT_OS), Linux)
	CURRENT_OS := $(shell lsb_release -si)
endif

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

TAG='rochacbruno/irpf'

all: build

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help:  ## This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: Build
build:  ## Build
	@echo "$(GREEN)==> Setup Build$(RESET)"
	docker build -t $(TAG) .

.PHONY: Start
start:  ## Start
ifeq ($(CURRENT_OS),Darwin)
ifeq (, $(shell command -v socat))
	$(error "No socat in $(PATH)")
endif
	socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$$DISPLAY\" && sleep 1 &
	DISPLAY="docker.for.mac.host.internal:0" docker-compose up
endif
ifeq ($(CURRENT_OS),Ubuntu)
	xhost +local:docker
	docker-compose up
endif
	make stop

stop:
	-docker-compose down
ifeq ($(CURRENT_OS),Ubuntu)
	-xhost -local:docker
endif
ifeq ($(CURRENT_OS),Darwin)
	-killall -9 socat
	-killall -9 Xquartz
endif

clean:
	make stop
	docker image rm $(TAG)

.PHONY: all clean
