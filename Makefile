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
VERSION = 0.8.0

SHELL := /bin/bash

VAGRANT = vagrant
DOCKER = "docker"

K8S_URI=https://storage.googleapis.com/kubernetes-release/release
K8S_VERSION=1.0.3
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

CALICO_URI=https://github.com/projectcalico/calico-docker/releases/download
CALICO_VERSION=0.5.5

DOCKER_URI=https://get.docker.com/builds/Linux/x86_64
DOCKER_VERSION=1.6.2

TERRAFORM_URI=https://dl.bintray.com/mitchellh/terraform
TERRAFORM_VERSION=0.6.3
TERRAFORM_ARCH=linux_amd64

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

OUTPUT=bin

all: help

help:
	@echo -e "$(OK_COLOR) ==== [$(APP)] [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- init$(NO_COLOR)    : Initialize environment$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- archive$(NO_COLOR) : Build K8S binaries archive$(NO_COLOR)"

configure:
	@mkdir -p ./bin

etcd: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Etcd$(NO_COLOR)"
	@curl --silent -L -o /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz $(ETCD_URI)/v$(ETCD_VERSION)/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz && \
		tar zxf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz -C /tmp/ && \
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

.PHONY: calico
calico: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Calico$(NO_COLOR)"
	curl --silent -o $(OUTPUT)/calicoctl -L ${CALICO_URI}/v${CALICO_VERSION}/calicoctl
	chmod +x $(OUTPUT)/calicoctl

.PHONY: docker
docker: configure
	@echo -e "$(OK_COLOR)[$(APP)] Install Docker$(NO_COLOR)"
	curl --silent -o $(OUTPUT)/docker -L ${DOCKER_URI}/docker-${DOCKER_VERSION}
	chmod +x $(OUTPUT)/docker

.PHONY: prepare
prepare:
	cp $(OUTPUT)/etcd ansible/roles/master/files/
	cp $(OUTPUT)/etcdctl ansible/roles/master/files/
	cp $(OUTPUT)/kube-apiserver ansible/roles/master/files/
	cp $(OUTPUT)/kube-controller-manager ansible/roles/master/files/
	cp $(OUTPUT)/kube-scheduler ansible/roles/master/files/
	cp $(OUTPUT)/kube-proxy ansible/roles/minion/files/
	cp $(OUTPUT)/kubelet ansible/roles/minion/files/
	cp $(OUTPUT)/calicoctl ansible/roles/minion/files/

.PHONY: init
init: etcd k8s terraform prepare

.PHONY: archive
archive:
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes binaries archive$(NO_COLOR)"
	rm -rf output && mkdir -p output
	cp $(OUTPUT)/etcd output
	cp $(OUTPUT)/etcdctl output
	cp $(OUTPUT)/kubectl output
	cp $(OUTPUT)/kube-apiserver output
	cp $(OUTPUT)/kube-controller-manager output
	cp $(OUTPUT)/kube-scheduler output
	cp $(OUTPUT)/kube-proxy output
	cp $(OUTPUT)/kubelet output
	cp $(OUTPUT)/docker output
	cd output && sha256sum * > CHECKSUM
	tar -zcvf hyperion-$(VERSION).tar.gz -C output .
