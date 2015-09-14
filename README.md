# Hyperion

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Description

[hyperion][] creates a Cloud environment :

- Identical machine images creation is performed using [Packer][]
- Orchestrated provisioning is performed using [Terraform][]
- Applications managment is performed using [Kubernetes][]

## Kubernetes

### Kubernetes master

- maintains the state of the [Kubernetes][] server runtime
- API server
- Scheduler
- Registries (nodes, pod, service)
- Storage

### Kubernetes nodes

- Represents the Host where containers are created
- Components : PODs, Kubelet, Proxy

### Kubernetes components

- [etcd][] : A highly available key-value store for shared configuration and service discovery.
- apiserver : Provides the API for Kubernetes orchestration.
- controller-manager : Enforces Kubernetes services.
- scheduler : Schedules containers on hosts.
- proxy : Provides network proxy services.
- kubelet : Processes a container manifest so the containers are launched according to
how they are described.

## Initialization

Initialize environment:

    $ make init

Create Kubernetes binaries archive :

    $ make archive

## Machine image

Read guides to creates the machine for a cloud provider :

* [Google cloud](https://github.com/portefaix/hyperion/blob/packer/google/README.md)

## Cloud infratructure

Read guides to creates the infrastructure :

* [Google cloud](https://github.com/portefaix/hyperion/blob/infra/google/README.md)
* [AWS](https://github.com/portefaix/hyperion/blob/infra/aws/README.md)
* [Digitalocean](https://github.com/portefaix/hyperion/blob/infra/digitalocean/README.md)
* [Openstack](https://github.com/portefaix/hyperion/blob/infra/openstack/README.md)


## Usage

* Setup your Kubernetes configuration :

        $ export K8S_MASTER=x.x.x.x
        $ kubectl config set-cluster hyperion \
            --insecure-skip-tls-verify=true --server=${K8S_MASTER}

* Check [Kubernetes][] status :

        $ curl http://${K8S_MASTER}:8080/
        {
          "paths": [
             "/api",
             "/api/v1",
             "/api/v1beta3",
             "/healthz",
             "/healthz/ping",
             "/logs/",
             "/metrics",
             "/static/",
             "/swagger-ui/",
             "/swaggerapi/",
             "/ui/",
             "/version"
           ]
        }

* You could use the ``kubectl`` binary to manage your cluster :

        $ bin/kubectl -s ${K8S_MASTER}:8080 version
        Client Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.3", GitCommit:"61c6ac5f350253a4dc002aee97b7db7ff01ee4ca", GitTreeState:"clean"}
        Server Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.3", GitCommit:"61c6ac5f350253a4dc002aee97b7db7ff01ee4ca", GitTreeState:"clean"}

        $ bin/kubectl -s ${K8S_MASTER}:8080 get cs
        NAME                 STATUS    MESSAGE              ERROR
        controller-manager   Healthy   ok                   nil
        scheduler            Healthy   ok                   nil
        etcd-0               Healthy   {"health": "true"}   nil

        $ bin/kubectl -s ${K8S_MASTER}:8080 get nodes
        NAME      LABELS    STATUS
        NAME          LABELS                               STATUS
        x.x.x.x       kubernetes.io/hostname=x.x.x.x       Ready
        x.x.x.x       kubernetes.io/hostname=x.x.x.x       Ready

        $ bin/kubectl -s ${K8S_MASTER}:8080 cluster-info
        Kubernetes master is running at x.x.x.x:8080


* Creates namespaces :

        $ bin/kubectl -s ${K8S_MASTER}:8080 create -f namespaces/namespace-admin.json
        $ bin/kubectl -s ${K8S_MASTER}:8080 create -f namespaces/namespace-dev.json
        $ bin/kubectl -s ${K8S_MASTER}:8080 create -f namespaces/namespace-prod.json

        $ bin/kubectl -s ${K8S_MASTER}:8080 get namespaces
        NAME          LABELS             STATUS
        admin         name=admin         Active
        default       <none>             Active
        development   name=development   Active
        kube-system   name=kube-system   Active
        production    name=production    Active


# Services #

[cAdvisor][] exposes a simple UI for on-machine containers on port `4194`

For others services, see [hyperion-services][]


## Debug

### Ping all hosts

    $ ansible all -m ping -i <inventory>

### Check connection to hosts

You could retrieve facts from hosts to check connections :

    $ ansible all -m setup -a "filter=ansible_distribution*" -i <inventory>



## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE][] for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[hyperion]: https://github.com/portefaixhyperion
[hyperion-services]: https://github.com/portefaix/hyperion-services
[LICENSE]: https://github.com/portefaix/hyperion/blob/master/LICENSE
[Issue tracker]: https://github.com/portefaix/hyperion/issues

[kubernetes]: http://kubernetes.io/
[etcd]: https://github.com/coreos/etcd
[terraform]: https://terraform.io
[terraform]: https://packer.io


[vagrant]: https://www.vagrantup.com
[virtualbox]: https://www.virtualbox.org/

[cAdvisor]: https://github.com/google/cadvisor

[badge-license]: https://img.shields.io/badge/license-Apache_2-green.svg
[badge-release]: https://img.shields.io/github/release/portefaix/hyperion.svg
