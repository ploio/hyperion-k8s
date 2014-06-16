#!/bin/bash

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
HYPERION_DIR="/var/docker/hyperion"
HYPERION_WEB=9090
HYPERION_ES=9092
HYPERION_REDIS=9379
HYPERION_INFLUXDB=9083
HYPERION_INFLUXDB=9086

hyperion_pull() {
    sudo docker pull nlamirault/hyperion
}

hyperion_start() {
    sudo mkdir -p $HYPERION_DIR/{elasticsearch,graphite,supervisor,nginx,redis,influxdb}
    sudo chmod -R 777 $HYPERION_DIR/elasticsearch
    ID=$(sudo docker run -d \
              -v $HYPERION_DIR/elasticsearch:/var/lib/elasticsearch \
              -v $HYPERION_DIR/graphite:/var/lib/graphite/storage/whisper \
              -v $HYPERION_DIR/supervisor:/var/log/supervisor \
              -v $HYPERION_DIR/nginx:/var/log/nginx \
              -v $HYPERION_DIR/influxdb:/var/lib/influxdb \
              -p $HYPERION_WEB:80 \
              -p $HYPERION_ES:9200 \
              -p $HYPERION_REDIS:6379 \
              -p $HYPERION_INFLUXDB_UI:8083 \
              -p $HYPERION_INFLUXDB_API:8086 \
              -p 8125:8125/udp -p 2003:2003/tcp \
              -p 9222:22
              --name $NAME nlamirault/hyperion)
    echo "Hyperion ID : $ID"
}

hyperion_stop() {
    sudo docker stop $NAME
}

hyperion_clean() {
    sudo docker rm $NAME
}

hyperion_help() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  pull      :    Pull the Hyperion image from the registry"
    echo "  start     :    Start Hyperion container"
    echo "  stop      :    Stop Hyperion container"
    echo "  clean     :    Remove Hyperion container"
    echo "  help      :    Display this help"
}

if [ $# -eq 0 ]
then
    hyperion_help
    exit 0
fi

case $1 in
    pull)
        hyperion_pull
        ;;
    clean)
        hyperion_clean
        ;;
    start)
        hyperion_start
        ;;
    stop)
        hyperion_stop
        ;;
    *)
        hyperion_help
        ;;
esac
