# Hyperion

[![License GPL 3][badge-license]][COPYING]
[![wercker status](https://app.wercker.com/status/a6dff1d550ed9c6aa3c466045bf1d51f/s "wercker status")](https://app.wercker.com/project/bykey/a6dff1d550ed9c6aa3c466045bf1d51f)

## Description

[Hyperion][] is a [Docker][] (>= 0.11) image (Ubuntu 14.04 based), which provides on the host :
* `http://localhost:8080`: [Hyperion][] web description
* `http://localhost:8080/grafana`: the [Grafana][] web interface
* `http://localhost:8080/graphite`: the [Graphite][] web interface
* `http://localhost:8080/elasticsearch`: the [Elasticsearch][] web interface

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://localhost:8082/_plugin/head/`
* [ElasticHQ][]: `http://localhost:8082/_plugin/HQ/`
* [Kopf][]: `http://localhost:8082/_plugin/kopf`

It's a *Trusted Build* on the [Docker Index](https://index.docker.io/u/nlamirault/hyperion).



## Deployment

Get the container from the Docker index and launch it (Cf [Docker](http://docs.docker.io/) documentation).

You could use this [script](client/hyperion_client.py) to manage Hyperion container:
```bash
$ client/hyperion.sh help
Usage: client/hyperion.sh <command>
Commands:
  pull      :    Pull the Hyperion image from the registry
  start     :    Start Hyperion container
  stop      :    Stop Hyperion container
  help      :    Display this help
```

* A simple [Statsd][] client [hyperion_client.py](client/hyperion_client.py) to check [Hyperion][] installation :

        $ ./hyperion_client.py

See metrics on `http://localhost:9090/grafana`.

* A [Redis][] database is provided. So you could use [log shippers](http://cookbook.logstash.net/recipes/log-shippers) to sent logs to [Hyperion][].

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
[Nginx]: http://nginx.org
[Elasticsearch]: http://www.elasticsearch.org/
[Graphite]: http://graphite.readthedocs.org/en/latest
[Grafana]: http://grafana.org/
[Carbon]: http://graphite.readthedocs.org/en/latest/carbon-daemons.html
[Statsd]: https://github.com/etsy/statsd/wiki
[ElasticSearchHead]: http://mobz.github.io/elasticsearch-head/
[ElasticHQ]: http://www.elastichq.org
[Kopf]: https://github.com/lmenezes/elasticsearch-kopf
