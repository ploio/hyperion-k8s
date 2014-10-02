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
	@echo -e "$(OK_COLOR) ==== Hyperion [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - destroy$(NO_COLOR)        : Destroy Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - status$(NO_COLOR)         : State of the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - create$(NO_COLOR)         : Create the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - start$(NO_COLOR)          : Start the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - stop$(NO_COLOR)           : Stop the Hyperion cluster$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)  - docker$(NO_COLOR)         : Build the Docker images$(NO_COLOR)"

.PHONY: destroy
destroy:
	@echo -e "$(OK_COLOR) [hyperion] Destroying cluster$(NO_COLOR)"
	@$(VAGRANT) destroy -f
	@rm -f ssh.config

.PHONY: start
start:
	@echo -e "$(OK_COLOR) [hyperion] Starting cluster$(NO_COLOR)"
	@$(VAGRANT) start

.PHONY: stop
stop:
	@echo -e "$(OK_COLOR) [hyperion] Stoping cluster$(NO_COLOR)"
	@$(VAGRANT) stop

.PHONY: status
status:
	@echo -e "$(OK_COLOR) [hyperion] State of the cluster$(NO_COLOR)"
	@$(VAGRANT) status

.PHONY: create
create:
	@echo -e "$(OK_COLOR) [hyperion] Creates cluster$(NO_COLOR)"
	@$(VAGRANT) up
	@rm -f ssh.config
	@$(VAGRANT) ssh-config master > ssh.config
	@ssh -f -nNT -L 8080:127.0.0.1:8080 -F ssh.config master

.PHONY: docker-metrics
docker-metrics:
	@echo -e "$(OK_COLOR) [hyperion] Creates Docker Metrics images$(NO_COLOR)"
	@echo -e "$(WARN_COLOR) Build Docker Monitoring Metrics $(NO_COLOR)"
	@$(DOCKER) build -t nlamirault/hyperion-monitoring-metrics docker/monitoring-metrics/
	@echo -e "$(WARN_COLOR) Build Docker Monitoring UI $(NO_COLOR)"
	@$(DOCKER) build -t nlamirault/hyperion-monitoring-ui docker/monitoring-ui/

.PHONY: docker-logging
docker-logging:
	@echo -e "$(OK_COLOR) [hyperion] Creates Docker Logging images$(NO_COLOR)"
	@echo -e "$(WARN_COLOR) Build Docker Logging Metrics $(NO_COLOR)"
	@$(DOCKER) build -t nlamirault/hyperion-logging-metrics docker/logging-metrics/
	@echo -e "$(WARN_COLOR) Build Docker Logging UI $(NO_COLOR)"
	@$(DOCKER) build -t nlamirault/hyperion-logging-ui docker/logging-ui/

.PHONY: docker
docker: docker-metrics docker-logging
