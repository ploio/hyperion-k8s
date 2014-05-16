# Hyperion

[![License GPL 3][badge-license]][COPYING]

## Description

[Hyperion][] provides ElasticSearch + Graphite + StatsD + Graphana in a
[Docker][] container.
On the host :
- `http://localhost:8080`: the graphite web interface
- `http://localhost:8081`: the grafana web interface

## Deployment

* Get the container from the Docker index :

        $ docker pull nlamirault/hyperion

* Launch the container :

        $ sudo docker run -d \
            -v /var/docker/$(NAME)/elasticsearch:/var/lib/elasticsearch \
		    -v /var/docker/$(NAME)/graphite:/var/lib/graphite/storage/whisper \
		    -v /var/docker/$(NAME)/supervisor:/var/log/supervisor \
		    -p 8081:81 -p 8080:80 -p 8125:8125/udp -p 2003:2003/tcp \
		    --name hyperion nlamirault/hyperion


## Development

* Build the container :

        $ make

* Setup directories :

        $ sudo mkdir -p /var/docker/hyperion/{elasticsearch,graphite,supervisor}

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
