# Copyright (C) 2014  Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

MAIN=hyperion
DOCKER_HYPERION=/var/docker/$(MAIN)
NAME=$(MAIN)-elasticsearch
CONTAINER=nlamirault/$(NAME)
HYPERION_ES=9192

all: help

help:
	@echo " -- Hyperion / Elasticsearch --"
	@echo "   setup     : Creates directories used by Hyperion"
	@echo "   build     : Make the Docker image"
	@echo "   start     : Start a container"
	@echo "   stop      : Stop the container"

setup:
	@echo "Creates $(DOCKER_HYPERION) directories on host"
	sudo mkdir -p $(DOCKER_HYPERION)/elasticsearch
	sudo mkdir -p $(DOCKER_HYPERION)/nginx
	sudo chmod -R 777 $(DOCKER_HYPERION)/elasticsearch

destroy:
	@echo "Destroying $(DOCKER_HYPERION) directory on host"
	sudo rm -fr $(DOCKER_HYPERION)

reset: destroy setup

build:
	docker build -t $(CONTAINER) .

start:
	docker run \
	-v $(DOCKER_HYPERION)/elasticsearch:/var/lib/elasticsearch \
	-p $(HYPERION_ES):9200 \
	--name $(NAME) $(CONTAINER)

stop:
	docker stop $(NAME)

clean:
	docker rm $(NAME)
