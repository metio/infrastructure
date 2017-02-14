# http://www.gnu.org/software/make/manual/make.html
# https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html#Makefile-Basics
# http://clarkgrubb.com/makefile-style-guide

############
# PROLOGUE #
############
MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

######################
# INTERNAL VARIABLES #
######################
USERID := $(shell id -u)
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

######################
# INTERNAL FUNCTIONS #
######################
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'targets'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

###############
# GOALS/RULES #
###############
.PHONY: all
all: help

.PHONY: help
help: ##@other Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

.PHONY: PHONY
docker: ##@bare Run all Docker related tasks
	ansible-playbook -i hosts bare.yml --tags docker

.PHONY: nginx
nginx: ##@bare Run all nginx related tasks
	ansible-playbook -i hosts bare.yml --tags nginx

.PHONY: repository-all
repository-all: ##@repository Setup all of repository.metio.wtf
	ansible-playbook -i hosts repository.metio.wtf.yml

.PHONY: nexus
nexus: ##@repository Run all Nexus related tasks
	ansible-playbook -i hosts repository.metio.wtf.yml --tags nexus

.PHONY: build-all
build-all: ##@build Setup all of build.metio.wtf
	ansible-playbook -i hosts build.metio.wtf.yml

.PHONY: jenkins
jenkins: ##@build Run all Jenkins related tasks
	ansible-playbook -i hosts build.metio.wtf.yml --tags jenkins

.PHONY: quality-all
quality-all: ##@quality Setup all of quality.metio.wtf
	ansible-playbook -i hosts quality.metio.wtf.yml

.PHONY: sonarqube
sonarqube: ##@quality Run all SonarQube related tasks
	ansible-playbook -i hosts quality.metio.wtf.yml --tags sonarqube
