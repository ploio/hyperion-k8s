# Hyperion

[![License GPL 3][badge-license]][COPYING]
[![wercker status](https://app.wercker.com/status/a6dff1d550ed9c6aa3c466045bf1d51f/s "wercker status")](https://app.wercker.com/project/bykey/a6dff1d550ed9c6aa3c466045bf1d51f)

## Description

[Hyperion][] is a monitoring and logging system with. The stack :
* [Elasticsearch][] (v1.2.1) web interface : `http://xxx:9092/elasticsearch/`
* [Grafana][] (v1.5.4) web interface : `http://xxx:9090/grafana/`
* [Graphite][] (v3.1.0) web interface : `http://xxx:9090/graphite/`
* [Supervisor][] is used to manage processes.
* [InfluxDB][] (v0.7.3) web interface : `http://xxx:8083`

Some [Elasticsearch][] plugins are available:
* [ElasticSearchHead][]: `http://xxx:9092/_plugin/head/`
* [ElasticHQ][]: `http://xxx:9092/_plugin/HQ/`
* [Kopf][]: `http://xxx:9092/_plugin/kopf/`


## CoreOS

[CoreOS][] is a new linux distribution aimed at scalable deployments and
[Docker][] support.
[Fleet][] allows you to manage systemd based services on a cluster of machines.
[Kubernetes][] will be installed using systemd services and launch them with
[Fleet][].
[Etcd][] is a highly-available key value store for shared configuration and
service discovery

## Kubernetes


### Kubernetes master

- maintains the state of the [Kubernetes][] server runtime
- API server
- Scheduler
- Registries (minions, pod, service)
- Storage

### Kubernetes minions

- Represents the Host where containers are created
- Components : PODs, Kubelet, cAdvisor, Proxy


## Deployment

A `Vagrantfile` using [CoreOS][] (version 410.0.0) is provided if you want to
use it in virtual machines. This installation creates a [Kubernetes][] system
on a cluster of [CoreOS][] VMs:

* Install dependencies : [Virtualbox][] (>= 4.3.10), [Vagrant][] (>= 1.6),

* Help:

        $ make

* Initialize environment:

        $ make init
        $ . hyperionrc

* Creates the cluster :

        $ make create

* Management :

        $ kubecfg list minions
        Minion identifier
        ----------
        10.245.1.101
        10.245.1.102

* Deploy applications :

        $ kubecfg -c k8s/elasticsearch-pod.json create pods
        [...]
        $ kubecfg list pods
        ID                     Image(s)                   Host                Labels                      Status
        ----------             ----------                 ----------          ----------                  ----------
        elasticsearch-master   dockerfile/elasticsearch   10.245.1.101/       name=elasticsearch-master   Running

        $ kubecfg -c k8s/elasticsearch-service.json create services
        $ kubecfg list services
        ID                    Labels              Selector                    Port
        ----------            ----------          ----------                  ----------
        elasticsearchmaster                       name=elasticsearch-master   10000

        $ curl http://10.245.1.101:9200
        {
            "status" : 200,
            "name" : "Ent",
            "version" : {
                "number" : "1.3.2",
                "build_hash" : "dee175dbe2f254f3f26992f5d7591939aaefd12f",
                "build_timestamp" : "2014-08-13T14:29:30Z",
                "build_snapshot" : false,
                "lucene_version" : "4.9"
            },
            "tagline" : "You Know, for Search"
        }

        $ kubecfg -c k8s/monitoring-pod.json create pods
        $ kubecfg -c k8s/logging-pod.json create pods

        $ kubecfg -c k8s/monitoring-service.json create services
        $ kubecfg -c k8s/logging-service.json create services



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
[Kubernetes]: https://github.com/GoogleCloudPlatform/kubernetes

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
[sysinfo_influxdb]: https://github.com/novaquark/sysinfo_influxdb
