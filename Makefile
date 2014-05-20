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

NAME="hyperion"
CONTAINER="nlamirault/hyperion"
DOCKER_HYPERION="/var/docker/$(NAME)"

all: build

setup:
	sudo mkdir -p $(DOCKER_HYPERION)/elasticsearch
	sudo mkdir -p $(DOCKER_HYPERION)/graphite
	sudo mkdir -p $(DOCKER_HYPERION)/supervisor
	sudo mkdir -p $(DOCKER_HYPERION)/nginx

build:
	sudo docker build -t $(CONTAINER) .

stop:
	sudo docker kill $(NAME)

clean: stop
	sudo docker rm $(NAME)

run:
	sudo chmod -R 777 $(DOCKER_HYPERION)/elasticsearch
	sudo docker run -d \
		-v $(DOCKER_HYPERION)/elasticsearch:/var/lib/elasticsearch \
		-v $(DOCKER_HYPERION)/graphite:/var/lib/graphite/storage/whisper \
		-v $(DOCKER_HYPERION)/supervisor:/var/log/supervisor \
		-v $(DOCKER_HYPERION)/nginx:/var/log/nginx \
		-p 8080:80 \
		-p 8125:8125/udp -p 2003:2003/tcp \
		--name $(NAME) $(CONTAINER)
