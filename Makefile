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

NAME=hyperion
CONTAINER=nlamirault/hyperion
DOCKER_HYPERION=/var/docker/$(NAME)

all: build

setup:
	@echo "Creates $(DOCKER_HYPERION) directories on host"
	sudo mkdir -p $(DOCKER_HYPERION)/elasticsearch
	sudo mkdir -p $(DOCKER_HYPERION)/graphite
	sudo mkdir -p $(DOCKER_HYPERION)/supervisor
	sudo mkdir -p $(DOCKER_HYPERION)/nginx
	sudo mkdir -p $(DOCKER_HYPERION)/redis
	sudo chmod -R 777 $(DOCKER_HYPERION)/elasticsearch

destroy:
	@echo "Destroying $(DOCKER_HYPERION) directory on host"
	sudo rm -fr $(DOCKER_HYPERION)

reset: destroy setup

build:
	sudo docker build -t $(CONTAINER) .

start:
	client/hyperion.sh start

stop:
	client/hyperion.sh stop

clean:
	client/hyperion.sh clean
