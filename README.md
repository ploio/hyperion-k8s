# Hyperion

[![License Apache 2][badge-license]][LICENSE]

## Description

### Kubernetes master

- maintains the state of the [Kubernetes][] server runtime
- API server
- Scheduler
- Registries (minions, pod, service)
- Storage

### Kubernetes minions

- Represents the Host where containers are created
- Components : PODs, Kubelet, Proxy

## Deployment

A `Vagrantfile` is provided if you want to use it in virtual machines.
This installation creates a [Kubernetes][] system on a cluster of Ubuntu VMs:

* Install dependencies :
- [Virtualbox][] (>= 4.3.10),
- [Vagrant][] (>= 1.6),

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



## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE][] for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[Hyperion]: https://github.com/nlamirault/hyperion
[COPYING]: https://github.com/nlamirault/hyperion/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/hyperion/issues
