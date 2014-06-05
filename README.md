# Hyperion

[![License GPL 3][badge-license]][COPYING]
[![wercker status](https://app.wercker.com/status/a6dff1d550ed9c6aa3c466045bf1d51f/s "wercker status")](https://app.wercker.com/project/bykey/a6dff1d550ed9c6aa3c466045bf1d51f)

## Description

[Hyperion][] is a [Docker][] (>= 0.11) image (Ubuntu 14.04 based) containing :
* `http://xxx:9090`: [Hyperion][] web description
* `http://xxx:9090/grafana`: the [Grafana][] web interface
* `http://xxx:9090/graphite`: the [Graphite][] web interface
* `http://xxx:9092/elasticsearch`: the [Elasticsearch][] web interface

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://xxx:9092/_plugin/head/`
* [ElasticHQ][]: `http://xxx:9092/_plugin/HQ/`
* [Kopf][]: `http://xxx:9092/_plugin/kopf`

A [Redis][] database is provided. So you could use [log shippers](http://cookbook.logstash.net/recipes/log-shippers) to sent logs to [Hyperion][].

A simple [Statsd][] client [hyperion_client.py](client/hyperion_client.py) to check [Hyperion][] installation and send some metrics.

It's a *Trusted Build* on the [Docker Index](https://index.docker.io/u/nlamirault/hyperion).


## Local deployment

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


* Test your local installation :

        $ ./hyperion_client.py

* Go to `http://localhost:9090/`


## Virtualbox deployment

A `Vagrantfile` using [CoreOS][] (version 324.2.0) is provided if you want to use it in a VM.

* Install dependencies :
- [Virtualbox][] 4.3.10 or greater.
- [Vagrant][] 1.6 or greeter

* Launch VM:

        $ vagrant up
        $ vagrant ssh

* Test your installation:

        $ ./hyperion_client.py -s 10.1.2.3 -p 8125

* Go to `http://10.1.2.3:9090/`


## Development

* Build the container :

        $ make clean && make

* Setup directories :

        $ sudo mkdir -p /var/docker/hyperion/{elasticsearch,graphite,supervisor,nginx}

* Start the container :

        $ make start

* Launch unit tests :

        $ tox


## Support

Feel free to ask question or make suggestions in our [Issue Tracker][].


## License

Scame is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

Scame is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

See [COPYING][] for the complete license.


## Changelog

A changelog is available [here](ChangeLog.md).


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>



[Hyperion]: https://github.com/nlamirault/hyperion
[COPYING]: https://github.com/nlamirault/scame/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/hyperion/issues

[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat

[Docker]: https://www.docker.io
[CoreOS]: http://coreos.com
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
