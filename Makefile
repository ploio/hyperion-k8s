# Copyright (C) 2014, 2015 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APP = hyperion
VERSION = 0.2.0

SHELL := /bin/bash

VAGRANT = vagrant
DOCKER = "docker"

K8S_URI=https://storage.googleapis.com/kubernetes-release/release
K8S_VERSION=1.0.1
K8S_ARCH=linux/amd64
K8S_BINARIES = \
	kube-apiserver \
	kube-proxy \
	kube-scheduler \
	kube-controller-manager \
	kubelet \
	kubectl

ETCD_URI=https://github.com/coreos/etcd/releases/download
ETCD_VERSION=2.1.1

TERRAFORM_URI=https://dl.bintray.com/mitchellh/terraform
TERRAFORM_VERSION=0.6.1
TERRAFORM_ARCH=linux_amd64

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

OUTPUT=bin

all: help

help:
	@echo -e "$(OK_COLOR) ==== [$(APP)] [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - init$(NO_COLOR)                        : Initialize environment$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - create$(NO_COLOR)                      : Creates the cluster [vagrant]$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - destroy$(NO_COLOR)                     : Destroy the cluster [vagrant]$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - vagrant-master$(NO_COLOR)              : Configure the master [vagrant]$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - vagrant-nodes$(NO_COLOR)               : Configure the nodes [vagrant]$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - master inventory=<filename>$(NO_COLOR) : Configure the master $(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - nodes inventory=<filename>$(NO_COLOR)  : Configure the nodes$(NO_COLOR)"


configure:
	@mkdir -p ./bin

etcd: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Etcd$(NO_COLOR)"
	@curl --silent -L -o /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz $(ETCD_URI)/v$(ETCD_VERSION)/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz && \
		tar zxvf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz -C /tmp/ && \
		cp -f /tmp/etcd-v$(ETCD_VERSION)-linux-amd64/etcdctl bin && \
		cp -f /tmp/etcd-v$(ETCD_VERSION)-linux-amd64/etcd bin && \
		rm -rf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz /tmp/etcd-v$(ETCD_VERSION)-linux-amd64

.PHONY: k8s
k8s: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Kubernetes$(NO_COLOR)"
	for i in $(K8S_BINARIES); do \
		curl --silent -o $(OUTPUT)/$$i -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/$$i; \
		chmod +x $(OUTPUT)/$$i; \
	done

.PHONY: terraform
terraform: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Terraform$(NO_COLOR)"
	curl --silent -o /tmp/terraform-v${TERRAFORM_VERSION}.zip -L ${TERRAFORM_URI}/terraform_${TERRAFORM_VERSION}_$(TERRAFORM_ARCH).zip && \
		unzip /tmp/terraform-v${TERRAFORM_VERSION}.zip -d $(OUTPUT) && \
		rm -rf /tmp/terraform-v${TERRAFORM_VERSION}.zip

.PHONY: prepare
prepare:
	cp $(OUTPUT)/etcd ansible/roles/master/files/
	cp $(OUTPUT)/kube-apiserver ansible/roles/master/files/
	cp $(OUTPUT)/kube-controller-manager ansible/roles/master/files/
	cp $(OUTPUT)/kube-scheduler ansible/roles/master/files/
	cp $(OUTPUT)/kube-proxy ansible/roles/minion/files/
	cp $(OUTPUT)/kubelet ansible/roles/minion/files/

.PHONY: init
init: etcd k8s prepare

.PHONY: create
create:
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes cluster$(NO_COLOR)"
	@vagrant up

.PHONY: destroy
destroy:
	@echo -e "$(OK_COLOR)[$(APP)] Destroy Kubernetes cluster$(NO_COLOR)"
	@vagrant destroy -f

.PHONY: vagrant-master
vagrant-master:
	@echo -e "$(OK_COLOR)[$(APP)] Configure Kubernetes master$(NO_COLOR)"
	@ansible-playbook -vvvv -i ansible/hyperion --private-key=$(HOME)/.vagrant.d/insecure_private_key -u vagrant ansible/master.yml

.PHONY: vagrant-nodes
vagrant-nodes:
	@echo -e "$(OK_COLOR)[$(APP)] Configure Kubernetes nodes$(NO_COLOR)"
	@ansible-playbook -vvvv -i ansible/hyperion --private-key=$(HOME)/.vagrant.d/insecure_private_key -u vagrant ansible/nodes.yml

.PHONY: master
master:
	@echo -e "$(OK_COLOR)[$(APP)] Configure Kubernetes master$(NO_COLOR)"
	@ansible-playbook -vvvv --private-key=/home/nlamirault/.ssh/id_rsa -i $(inventory)  ansible/master.yml

.PHONY: nodes
nodes:
	@echo -e "$(OK_COLOR)[$(APP)] Configure Kubernetes nodes$(NO_COLOR)"
	@ansible-playbook -vvvv --private-key=/home/nlamirault/.ssh/id_rsa -i $(inventory) ansible/nodes.yml

.PHONY: test
test:
	@echo -e "$(OK_COLOR)[$(APP)] Test Kubernetes $(NO_COLOR)"
	@ansible-playbook -vvvv --private-key=/home/nlamirault/.ssh/id_rsa -i $(inventory) ansible/test.yml
