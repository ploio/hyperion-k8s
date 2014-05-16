# Hyperion

## Description

ElasticSearch + Graphite + Graphana in a Docker container.
Provides :
- `80`: the graphite web interface
- `81`: the grafana web interface
- `2003`: the carbon-cache line receiver (the standard graphite protocol)
- `2004`: the carbon-cache pickle receiver
- `7002`: the carbon-cache query port (used by the web interface)

You can log into the administrative interface of graphite-web (a Django
application) with the username `admin` and password `admin`. These passwords can
be changed through the web interface.

## Deployment

* Build the container :

        $ make

* Once the container is available, push it to the [Docker Index](index.docker.io) :

        $ sudo docker login
        $ sudo docker push <yourname>/<name>

* Setup directories :

        $ sudo mkdir -p /var/docker/hyperion/{elasticsearch,graphite,supervisor}

* Start the container :

        $ make run

# UI

* [DockerUI](https://github.com/crosbymichael/dockerui) could be used to display available containers :

        $ docker pull crosbymichael/dockerui
        $ docker run -d crosbymichael/dockerui -e="http://127.0.0.1:4243"

## Copyright

Copyright (c) Nicolas Lamirault <nicolas.lamirault@gmail.com>
