# Hyperion

[![License GPL 3][badge-license]][COPYING]
[![wercker status](https://app.wercker.com/status/a6dff1d550ed9c6aa3c466045bf1d51f/s "wercker status")](https://app.wercker.com/project/bykey/a6dff1d550ed9c6aa3c466045bf1d51f)

## Description

[Hyperion][] is an application which provides a monitoring and log collector solution. The stack is :
* [CoreOS][] : Linux-based operating system aimed at large-scale server deployments
* [Docker][] : an open platform for distributed applications
* [Confd][] : the configuration management tool built on top of etcd
* [Etcd][]: a highly-available key value store for shared configuration and service discovery
* [Fleet][]: a Distributed init System (on top-of Systemd)

Components :
* [Elasticsearch][] (v1.2.1) web interface : `http://xxx:9092/`
* [Grafana][] (v1.5.4) web interface : `http://xxx:9090/grafana/`
* [Graphite][] (v3.1.0) web interface : `http://xxx:9090/graphite/`
* [Statsd][] (v0.7.1) daemon on `8125` and `8126`
* [Supervisor][] is used to manage processes.
* [InfluxDB][] (v0.7.3) web interface : `http://xxx:8083`

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://xxx:9092/_plugin/head/`
* [ElasticHQ][]: `http://xxx:9092/_plugin/HQ/`
* [Kopf][]: `http://xxx:9092/_plugin/kopf/`


## Deployment

A `Vagrantfile` using [CoreOS][] (version 324.2.0) is provided if you want to use it in a virtual machine. This virtual machine is sharing volume `/var/docker/hyperion` between host and guest machine to store metrics.

* Install dependencies : [Virtualbox][] (>= 4.3.10), [Vagrant][] (>= 1.6), NFS server

* Launch VM:

        $ vagrant up

* Test your installation using [hyperion_client.py](addons/hyperion_client.py):

        $ ./hyperion_client.py -s 10.1.2.3 -p 8125

* Go to `http://10.1.2.3:9090/`

* You could connect to your virtual machine by ssh to manage your installation using [CoreOS][] tools ([Etcd][] and [Fleet][]).

        $ vagrant ssh
        $ fleetctl list-units
        UNIT			STATE		LOAD	ACTIVE	SUB	DESC		MACHINE
        hyperion-elasticsearch.service	launched	loaded	active	running	hyperion elasticsearch	5b239548.../10.1.2.3
        $ fleetctl status hyperion-elasticsearch.service
        ● hyperion-elasticsearch.service - hyperion elasticsearch
          Loaded: loaded (/run/fleet/units/hyperion-elasticsearch.service; linked-runtime)
          Active: active (running) since Mon 2014-06-16 20:40:13 UTC; 3min 26s ago
        Main PID: 3570 (docker)
          CGroup: /system.slice/hyperion-elasticsearch.service
                  └─3570 /usr/bin/docker run --rm -v /var/docker/hyperion/elasticsearch:/var/lib/elasticsearch -v /var/docker/hyperion/supervisor:/var/log/supervisor -p 9092:9200 -e HOST_IP= --name hyperion-elasticsearch nlamirault/hyperion-elasticsearch


## Usage

You could use [Hyperion][] to collect event and logs from hosts.

### Fluentd

Using this file [fluent.conf][] for [Fluentd][] and send logs :

    $ gem install fluentd
    $ gem install fluent-plugin-elasticsearch
    $ fluentd -c fluent.conf

### Heka

Using this file [hekad.toml][] for [Heka][] and send logs :

    $ wget https://github.com/mozilla-services/heka/releases/download/v0.5.2/heka_0.5.2_amd64.deb
    $ dpkg -i heka_0.5.2_amd64.deb
    $ hekad -config=hekad.toml


## Development

* Build the container :

        $ make clean && make

* Setup directories :

        $ sudo mkdir -p /var/docker/hyperion/{elasticsearch,graphite,supervisor,nginx}

* Start the container :

        $ make start

* You could launch unit tests using local installation or VM installation :

        $ tox
        $ tox -evm


## Support

Feel free to ask question or make suggestions in our [Issue Tracker][].


## License

Hyperion is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

Hyperion is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

See [COPYING][] for the complete license.


## Changelog

A changelog is available [here](ChangeLog.md).


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>



[Hyperion]: https://github.com/nlamirault/hyperion
[COPYING]: https://github.com/nlamirault/hyperion/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/hyperion/issues
[fluent.conf]: https://github.com/nlamirault/hyperion/blob/master/logs/fluent.conf
[hekad.toml]: https://github.com/nlamirault/hyperion/blob/master/logs/hekad.toml

[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat

[Docker]: https://www.docker.io
[CoreOS]: http://coreos.com
[Etcd]: http://coreos.com/using-coreos/etcd
[Confd]: https://github.com/kelseyhightower/confd
[Fleet]: https://github.com/coreos/fleet
[Nginx]: http://nginx.org
[Elasticsearch]: http://www.elasticsearch.org
[Redis]: http://www.redis.io
[Graphite]: http://graphite.readthedocs.org/en/latest
[Grafana]: http://grafana.org/
[Carbon]: http://graphite.readthedocs.org/en/latest/carbon-daemons.html
[Statsd]: https://github.com/etsy/statsd/wiki
[ElasticSearchHead]: http://mobz.github.io/elasticsearch-head
[ElasticHQ]: http://www.elastichq.org
[Kopf]: https://github.com/lmenezes/elasticsearch-kopf
[Virtualbox]: https://www.virtualbox.org
[Vagrant]: http://downloads.vagrantup.com
[Fluentd]: http://fluentd.org/
[Heka]: http://hekad.readthedocs.org/en/latest/
[Supervisor]: http://supervisord.org
