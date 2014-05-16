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

all: build

clean:
	sudo docker kill $(NAME)
	sudo docker rm $(NAME)

setup:
	sudo mkdir -p /var/docker/$(NAME)/elasticsearch
	sudo mkdir -p /var/docker/$(NAME)/graphite
	sudo mkdir -p /var/docker/$(NAME)/supervisor

build:
	sudo docker build -t $(CONTAINER) .

run:
	sudo docker run -d \
		-v /var/docker/$(NAME)/elasticsearch:/var/lib/elasticsearch \
		-v /var/docker/$(NAME)/graphite:/var/lib/graphite/storage/whisper \
		-v /var/docker/$(NAME)/supervisor:/var/log/supervisor \
		-p 8081:81 -p 8080:80 -p 8125:8125/udp -p 2003:2003/tcp \
		--name $(NAME) $(CONTAINER)
