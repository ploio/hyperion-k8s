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
VERSION = 0.10.0

SHELL := /bin/bash

VAGRANT = vagrant
DOCKER = "docker"

K8S_URI=https://storage.googleapis.com/kubernetes-release/release
K8S_VERSION=1.1.3
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

DOCKER_URI=https://get.docker.com/builds/Linux/x86_64
DOCKER_VERSION=1.9.1

FLANNEL_URI=https://github.com/coreos/flannel/releases/download
FLANNEL_VERSION=0.5.5

PACKER ?= packer
TERRAFORM = ?= terraform

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

OUTPUT=bin

all: help

help:
	@echo -e "$(OK_COLOR) ==== [$(APP)] [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- binaries$(NO_COLOR)           : Download binaries$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- archive$(NO_COLOR)            : Build K8S binaries archive$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- build provider=xxx$(NO_COLOR) : Build box for provider$(NO_COLOR)"

clean:
	rm -fr output hyperion-*.tar.gz

configure:
	@mkdir -p ./bin

etcd: configure
	@echo -e "$(OK_COLOR)[$(APP)] Download Etcd$(NO_COLOR)"
	@curl --silent -L -o /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz $(ETCD_URI)/v$(ETCD_VERSION)/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz && \
		tar zxf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz -C /tmp/ && \
		cp -f /tmp/etcd-v$(ETCD_VERSION)-linux-amd64/etcdctl bin && \
		cp -f /tmp/etcd-v$(ETCD_VERSION)-linux-amd64/etcd bin && \
		rm -rf /tmp/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz /tmp/etcd-v$(ETCD_VERSION)-linux-amd64

.PHONY: k8s
k8s: configure
	@echo -e "$(OK_COLOR)[$(APP)] Download Kubernetes$(NO_COLOR)"
	for i in $(K8S_BINARIES); do \
		curl --silent -o $(OUTPUT)/$$i -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/$$i; \
		chmod +x $(OUTPUT)/$$i; \
	done

.PHONY: docker
docker: configure
	@echo -e "$(OK_COLOR)[$(APP)] Download Docker$(NO_COLOR)"
	curl --silent -o $(OUTPUT)/docker -L ${DOCKER_URI}/docker-${DOCKER_VERSION}
	chmod +x $(OUTPUT)/docker

.PHONY: flannel
flannel: configure
	@echo -e "$(OK_COLOR)[$(APP)] Download Flannel$(NO_COLOR)"
	curl --silent -o /tmp/flannel-v${FLANNEL_VERSION}.tar.gz -L ${FLANNEL_URI}/v${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz && \
		tar zxvf /tmp/flannel-v${FLANNEL_VERSION}.tar.gz -C /tmp/ && \
		cp /tmp/flannel-${FLANNEL_VERSION}/flanneld $(OUTPUT)/flanneld && \
		rm -fr /tmp/flannel-${FLANNEL_VERSION} /tmp/flannel-v${FLANNEL_VERSION}.tar.gz

.PHONY: binaries
binaries: etcd k8s terraform docker flannel

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
	cp $(OUTPUT)/flanneld output
	cd output && sha256sum * > CHECKSUM
	tar -zcvf hyperion-k8s-$(VERSION).tar.gz -C output .
