# Copyright (C) 2014, 2015 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APP = hyperion
VERSION = 0.1.0

SHELL := /bin/bash

VAGRANT = vagrant
DOCKER = "docker"

K8S_URI=https://storage.googleapis.com/kubernetes-release/release
K8S_VERSION=0.19.1
K8S_ARCH=linux/amd64

ETCD_URI=https://github.com/coreos/etcd/releases/download
ETCD_VERSION=2.0.12

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

OUTPUT=bin

all: help

help:
	@echo -e "$(OK_COLOR) ==== [$(APP)] [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - init$(NO_COLOR)  : Initialize environment$(NO_COLOR)"

configure:
	@mkdir -p ./bin

etcd: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Etcd$(NO_COLOR)"
	@curl --silent -L -o /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz $(ETCD_URI)/v2.0.12/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz && \
		tar zxvf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz -C /tmp/ && \
		cp -f /tmp/etcd-v$(ETCD_VERSION)-linux-amd64/etcdctl bin && \
		cp -f /tmp/etcd-v$(ETCD_VERSION)-linux-amd64/etcd bin && \
		rm -rf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz /tmp/etcd-v$(ETCD_VERSION)-linux-amd64

.PHONY: k8s
k8s: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Kubernetes$(NO_COLOR)"
	curl --silent -o $(OUTPUT)/kube-apiserver -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/kube-apiserver && \
		chmod +x $(OUTPUT)/kube-apiserver
	curl --silent -o $(OUTPUT)/kube-proxy -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/kube-proxy && \
		chmod +x $(OUTPUT)/kube-proxy
	curl --silent -o $(OUTPUT)/kube-scheduler -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/kube-scheduler && \
		chmod +x $(OUTPUT)/kube-scheduler
	curl --silent -o $(OUTPUT)/kube-controller-manager -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/kube-controller-manager && \
		chmod +x $(OUTPUT)/kube-controller-manager
	curl --silent -o $(OUTPUT)/kubelet -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/kubelet && \
		chmod +x $(OUTPUT)/kubelet
	curl --silent -o $(OUTPUT)/kubectl -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/kubectl && \
		chmod +x $(OUTPUT)/kubectl

.PHONY: prepare
prepare:
	cp $(OUTPUT)/etcd ansible/roles/master/files/
	cp $(OUTPUT)/kube-apiserver ansible/roles/master/files/
	cp $(OUTPUT)/kube-controller-manager ansible/roles/master/files/
	cp $(OUTPUT)/kube-scheduler ansible/roles/master/files/
	cp $(OUTPUT)/kube-proxy ansible/roles/minion/files/
	cp $(OUTPUT)/kubelet ansible/roles/minion/files/

.PHONY: init
init: etcd k8s

.PHONY: configure-master
configure-master:
	@echo -e "$(OK_COLOR)[$(APP)] Configure Kubernetes master$(NO_COLOR)"
	@sudo ansible-playbook -i ansible/hyperion --private-key=.vagrant/machines/master/virtualbox/private_key -u vagrant ansible/master.yml

.PHONY: configure-minions
configure-minions:
	@echo -e "$(OK_COLOR)[$(APP)] Configure Kubernetes minions$(NO_COLOR)"
	@sudo ansible-playbook -i ansible/hyperion ansible/minions.playbook --private-key=.vagrant/machines/minion-1/virtualbox/private_key -u vagrant ansible/minions.yml
