# Copyright (C) 2014 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

APP = hyperion

SHELL := /bin/bash

VAGRANT = vagrant
DOCKER = "docker"

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

VERSION=$(shell \
        grep HYPERION_VERSION Vagrantfile \
        |awk -F'"' '{print $$2}')

all: help

help:
	@echo -e "$(OK_COLOR) ==== [$(APP)] [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - init$(NO_COLOR)           : Initialize environment$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - destroy$(NO_COLOR)        : Destroy Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - status$(NO_COLOR)         : State of the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - create$(NO_COLOR)         : Create the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - start$(NO_COLOR)          : Start the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - stop$(NO_COLOR)           : Stop the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - docker$(NO_COLOR)         : Build the Docker images$(NO_COLOR)"

configure:
	@mkdir -p ./bin

etcd:
	@echo -e "$(OK_COLOR)[$(APP)] Install etcdctl$(NO_COLOR)"
	@wget https://github.com/coreos/etcd/releases/download/v0.4.5/etcd-v0.4.5-linux-amd64.tar.gz -O /tmp/etcd-v0.4.5-linux-amd64.tar.gz
	@cd /tmp && gzip -dc etcd-v0.4.5-linux-amd64.tar.gz | tar -xof -
	@cp -f /tmp/etcd-v0.4.5-linux-amd64/etcdctl bin
	@rm -rf /tmp/etcd-v0.4.5-linux-amd64.tar.gz

fleet:
	@echo -e "$(OK_COLOR)[$(APP)] Install fleetctl$(NO_COLOR)"
	@wget https://github.com/coreos/fleet/releases/download/v0.8.3/fleet-v0.8.3-linux-amd64.tar.gz -O /tmp/fleet-v0.8.3-linux-amd64.tar.gz
	@cd /tmp && gzip -dc fleet-v0.8.3-linux-amd64.tar.gz | tar -xof -
	@cp -f /tmp/fleet-v0.8.3-linux-amd64/fleetctl bin
	@rm -fr /tmp/fleet-v0.8.3-linux-amd64.tar.gz

kubecfg:
	@echo -e "$(OK_COLOR)[$(APP)] Install kubecfg$(NO_COLOR)"
	@wget https://storage.googleapis.com/kubernetes/kubecfg -O ./bin/kubecfg
	@chmod +x ./bin/kubecfg

.PHONY: k8s
k8s:
	@echo -e "$(OK_COLOR)[$(APP)] Install kubernetes$(NO_COLOR)"
	@wget -N -P ./bin http://storage.googleapis.com/kubernetes/kubelet && \
		chmod +x ./bin/kubelet
	@wget -N -P ./bin http://storage.googleapis.com/kubernetes/proxy && \
		chmod +x ./bin/proxy
	@wget -N -P ./bin http://storage.googleapis.com/kubernetes/apiserver && \
		chmod +x ./bin/apiserver
	@wget -N -P ./bin http://storage.googleapis.com/kubernetes/controller-manager && \
		chmod +x ./bin/controller-manager
	@wget -N -P ./bin http://storage.googleapis.com/kubernetes/scheduler && \
		chmod +x ./bin/scheduler

.PHONY: init
init: configure etcd fleet kubecfg k8s

.PHONY: destroy
destroy:
	@echo -e "$(OK_COLOR)[$(APP)] Destroying cluster$(NO_COLOR)"
	@$(VAGRANT) destroy -f
	@rm -f ssh.config

.PHONY: start
start:
	@echo -e "$(OK_COLOR)[$(APP)] Starting cluster$(NO_COLOR)"
	@$(VAGRANT) up

.PHONY: stop
stop:
	@echo -e "$(OK_COLOR)[$(APP)] Stoping cluster$(NO_COLOR)"
	@$(VAGRANT) halt

.PHONY: status
status:
	@echo -e "$(OK_COLOR)[$(APP)] State of the cluster$(NO_COLOR)"
	@$(VAGRANT) status

.PHONY: create
create:
	@echo -e "$(OK_COLOR)[$(APP)] Creates cluster$(NO_COLOR)"
	@$(VAGRANT) up
	@rm -f ssh.config
	@$(VAGRANT) ssh-config master > ssh.config
	@ssh -f -nNT -L 8080:10.245.1.100:8080 -F ssh.config master

docker-build:
	@echo -e "$(OK_COLOR)[$(APP)] Creates Docker image $image $(NO_COLOR)"
	@$(DOCKER) build -t nlamirault/hyperion-$(image) docker/$(image)

k8s-start:
	@echo -e "$(OK_COLOR)[$(APP)] Kubernetes start $(NO_COLOR)"
	./tools/start-pods.sh
	./tools/start-services.sh

k8s-stop:
	@echo -e "$(OK_COLOR)[$(APP)] Kubernetes stop $(NO_COLOR)"
	./tools/stop-pods.sh
	./tools/stop-services.sh
