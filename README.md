# Hyperion

[![License GPL 3][badge-license]][COPYING]

## Description

[Hyperion][] provides ElasticSearch + Graphite + Graphana in a Docker container.
On the host :
- `http://localhost:8080`: the graphite web interface
- `http://localhost:8081`: the grafana web interface

## Deployment

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
[COPYING]: https://github.com/nlamirault/scame/blob/master/COPYING
[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat
[Issue tracker]: https://github.com/nlamirault/hyperion/issues
