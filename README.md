# Hyperion

[![License GPL 3][badge-license]][COPYING]

## Description

[Hyperion][] is a [Docker][] image, which provides on the host :
* `http://localhost:8080`: [Hyperion][] web description
* `http://localhost:8080/grafana`: the [Grafana][] web interface
* `http://localhost:8080/graphite`: the [Graphite][] web interface
* `http://localhost:8080/elasticsearch`: the [Elasticsearch][] web interface

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://localhost:8082/_plugin/head/`
* [ElasticHQ][]: `http://localhost:8082/_plugin/HQ/`
* [Kopf][]: `http://localhost:8082/_plugin/kopf`

## Deployment

* Get the container from the Docker index :

        $ docker pull nlamirault/hyperion

* Launch the container :

        $ sudo mkdir -p /var/docker/hyperion/{elasticsearch,graphite,supervisor,nginx}
        $ sudo docker run -d \
            -v /var/docker/hyperion/elasticsearch:/var/lib/elasticsearch \
		    -v /var/docker/hyperion/graphite:/var/lib/graphite/storage/whisper \
		    -v /var/docker/hyperion/supervisor:/var/log/supervisor \
   		    -v /var/docker/hyperion/nginx:/var/log/nginx \
		    -p 8080:80 -p 8082:9200 \
            -p 8125:8125/udp -p 2003:2003/tcp \
		    --name hyperion nlamirault/hyperion

* Test using the [Statsd][] client [hyperion_client.py][]

        $ ./hyperion_client.py

See metrics on `http://localhost:8082/grafana`.


## Development

* Build the container :

        $ make

* Setup directories :

        $ sudo mkdir -p /var/docker/hyperion/{elasticsearch,graphite,supervisor,nginx}

* Start the container :

        $ make run

* Once the container is available, push it to the [Docker Index](index.docker.io) :

        $ sudo docker login
        $ sudo docker push <yourname>/<name>


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
[Docker]: https://www.docker.io
[COPYING]: https://github.com/nlamirault/scame/blob/master/COPYING
[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat
[Issue tracker]: https://github.com/nlamirault/hyperion/issues

[Nginx]: http://nginx.org
[Elasticsearch]: http://www.elasticsearch.org/
[Graphite]: http://graphite.readthedocs.org/en/latest
[Carbon]: http://graphite.readthedocs.org/en/latest/carbon-daemons.html
[Statsd]: https://github.com/etsy/statsd/wiki

[ElasticSearchHead]: http://mobz.github.io/elasticsearch-head/
[ElasticHQ]: http://www.elastichq.org
[Kopf]: https://github.com/lmenezes/elasticsearch-kopf

[hyperion_client]: https://github.com/nlamirault/hyperion/blob/master/client/hyperion_client.py
