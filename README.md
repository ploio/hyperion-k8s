# Hyperion

[![License GPL 3][badge-license]][COPYING]
[![wercker status](https://app.wercker.com/status/a6dff1d550ed9c6aa3c466045bf1d51f/s "wercker status")](https://app.wercker.com/project/bykey/a6dff1d550ed9c6aa3c466045bf1d51f)

## Description

[Hyperion][] is a [Docker][] (>= 0.11) image (Ubuntu 14.04 based) containing :
* [Hyperion][] web description : `http://xxx:9090`
* [Elasticsearch][] (v1.2.1) web interface : `http://xxx:9092/elasticsearch/`
* [Grafana][] (v1.5.4) web interface : `http://xxx:9090/grafana/`
* [Graphite][] (v3.1.0) web interface : `http://xxx:9090/graphite/`
* [Statsd][] (v0.7.1) daemon on `8125` and `8126`
* [Supervisor][] is used to manage processes.
* [InfluxDB][] (v0.7.3) web interface : `http://xxx:8083`

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://xxx:9092/_plugin/head/`
* [ElasticHQ][]: `http://xxx:9092/_plugin/HQ/`
* [Kopf][]: `http://xxx:9092/_plugin/kopf/`

It's a *Trusted Build* on the [Docker Hub](https://registry.hub.docker.com/u/nlamirault/hyperion).


## Deployment

### Local

Get the container from the Docker index and launch it (Cf [Docker documentation](http://docs.docker.io/)). You could use this [script](client/hyperion.sh) to help you :
```bash
$ client/hyperion.sh help
Usage: client/hyperion.sh <command>
Commands:
  pull      :    Pull the Hyperion image from the registry
  start     :    Start Hyperion container
  stop      :    Stop Hyperion container
  help      :    Display this help
```

* Install it:

        $ ./hyperion.sh pull && ./hyperion.sh start

* Test your local installation using [hyperion_client.py](client/hyperion_client.py):

        $ ./hyperion_client.py

* Go to `http://localhost:9090/`


### Virtualbox

A `Vagrantfile` using [CoreOS][] (version 324.2.0) is provided if you want to use it in a virtual machine. This virtual machine is sharing volume `/var/docker/hyperion` between host and guest machine to store metrics.

* Install dependencies : [Virtualbox][] (>= 4.3.10), [Vagrant][] (>= 1.6), NFS server

* Launch VM:

        $ vagrant up

* Test your installation using [hyperion_client.py](client/hyperion_client.py):

        $ ./hyperion_client.py -s 10.1.2.3 -p 8125

* Go to `http://10.1.2.3:9090/`

* You could connect to your virtual machine by ssh to manage your installation using [CoreOS][] tools ([Etcd][] and [Fleet][]).

        $ vagrant ssh
        $ fleetctl list-units
        UNIT			STATE		LOAD	ACTIVE	SUB	DESC		MACHINE
        hyperion.service	launched	loaded	active	running	Hyperion	c1adaa61.../10.1.2.3
        $ fleetctl status hyperion.service
        ● hyperion.service - Hyperion
        Loaded: loaded (/etc/systemd/system/hyperion.service; linked-runtime)
        Active: active (running) since Wed 2014-06-10 22:07:42 UTC; 10min ago
        Main PID: 3314 (docker)
            CGroup: /system.slice/hyperion.service
                    └─3314 /usr/bin/docker run -rm -v /var/docker/hyperion/elasticsearch:/var/lib/elasticsearch -v /var/docker/hyperion/graphite:/var/lib/graphite/storage/whisper -v /var/docker/hyperion/supervisor:/var/log/supervisor -v /var/docker/hyperion/nginx:/var/log/nginx -p 9090:80 -p 9092:9200 -p 9379:6379 -p 8125:8125/udp -p 2003:2003/tcp --name hyperion nlamirault/hyperion

        Jun 10 22:07:44 hyperion docker[3314]: 2014-06-10 22:07:44,643 INFO spawned: 'carbon-cache' with pid 17
        Jun 10 22:07:44 hyperion docker[3314]: 2014-06-10 22:07:44,657 INFO spawned: 'elasticsearch' with pid 18



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
[Fleet]: http://coreos.com/using-coreos/clustering/
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
