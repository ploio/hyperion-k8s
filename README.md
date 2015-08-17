# Hyperion

[![License Apache 2][badge-license]][LICENSE](LICENSE)
![Version][badge-release]


## Description

This installation creates a [Kubernetes][] cluster.

Dependencies :

- [virtualbox][] (>= 4.3.10)
- [vagrant][] (>= 1.6)
- [ansible][]
- [terraform][]


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

## Infra

Initialize environment:

    $ make init

### Local

* Creates the cluster :

        $ make create

### Cloud

Orchestrated provisioning is performed using [Terraform][].
Install it :

    $ make terraform

Read guides to creates the infrastructure :

* [Digitalocean](https://github.com/nlamirault/hyperion/blob/infra/digitalocean/README.md)
* [Google cloud](https://github.com/nlamirault/hyperion/blob/infra/google/README.md)


## Deployment

### Local

* Configure the cluster :

        $ make vagrant-master
        $ make vagrant-nodes

* Destroy the cluster:

        $ make destroy

### Cloud

* Setup an inventory file, like that :

        ```bash
        [masters]
        x.x.x.x ansible_connection=ssh ansible_ssh_user=hyperion ansible_python_interpreter=/usr/bin/python2

        [nodes]
        x.x.x.x ansible_connection=ssh ansible_ssh_user=hyperion ansible_python_interpreter=/usr/bin/python2
        x.y.y.y ansible_connection=ssh ansible_ssh_user=hyperion ansible_python_interpreter=/usr/bin/python2

        [etcd]
        x.x.x.x ansible_connection=ssh ansible_ssh_user=hyperion ansible_python_interpreter=/usr/bin/python2
        ```

* Configure the cluster :

        $ make master inventory=<inventory_filename>
        $ make nodes inventory=<inventory_filename>



## Usage

* Setup your kubernetes master IP :

        $ export K8S_MASTER=x.x.x.x

* Check [Kubernetes][] status :

        $ curl http://$(K8S_MASTER):8080/
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

        $ bin/kubectl -s $(K8S_MASTER):8080 version
        Client Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.1", GitCommit:"6a5c06e3d1eb27a6310a09270e4a5fb1afa93e74", GitTreeState:"clean"}
        Server Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.1", GitCommit:"6a5c06e3d1eb27a6310a09270e4a5fb1afa93e74", GitTreeState:"clean"}

        $ bin/kubectl -s 10.245.1.10:8080 get cs
        NAME                 STATUS    MESSAGE              ERROR
        controller-manager   Healthy   ok                   nil
        scheduler            Healthy   ok                   nil
        etcd-0               Healthy   {"health": "true"}   nil

        $ bin/kubectl -s $(K8S_MASTER):8080 get nodes
        NAME      LABELS    STATUS

        $ bin/kubectl -s $(K8S_MASTER):8080 get namespaces
        NAME      LABELS    STATUS
        default   <none>    Active

        $ bin/kubectl -s $(K8S_MASTER):8080 cluster-info
        Kubernetes master is running at $(K8S_MASTER):8080

* Creates namespaces :

        $ bin/kubectl -s $(K8S_MASTER):8080 create -f namespaces/namespace-admin.json
        $ bin/kubectl -s $(K8S_MASTER):8080 create -f namespaces/namespace-dev.json
        $ bin/kubectl -s $(K8S_MASTER):8080 create -f namespaces/namespace-prod.json
        $ bin/kubectl -s $(K8S_MASTER):8080 get namespaces
        NAME          LABELS             STATUS
        default       <none>             Active
        development   name=development   Active
        kube-system   name=kube-system   Active
        production    name=production    Active


### Setup Kubernetes UI

* Creates the replication controller and service :

        $ bin/kubectl -s $(K8S_MASTER):8080 create -f services/kube-ui/kube-ui-rc.yaml --namespace=kube-system
        $ bin/kubectl -s $(K8S_MASTER):8080 create -f -f services/kube-ui/kube-ui-svc.yaml --namespace=kube-system


### Setup heapster

* Create the pod :

        $ bin/kubectl -s $(K8S_MASTER):8080 create --namespace=admin -f services/monitoring/influxdb-grafana-controller.json
        $ bin/kubectl -s $(K8S_MASTER):8080 create --namespace=admin -f services/monitoring/heapster-controller.json
        $ bin/kubectl -s $(K8S_MASTER):8080 --namespace=admin get pods
        NAME                                         READY     STATUS    RESTARTS   AGE
        monitoring-influx-grafana-controller-hc0uh   2/2       Running   0          4m

* Create the monitoring services :





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


[Hyperion]: https://github.com/nlamirault/hyperion
[COPYING]: https://github.com/nlamirault/hyperion/blob/master/COPYING
[Issue tracker]: https://github.com/nlamirault/hyperion/issues

[kubernetes]: http://kubernetes.io/
[etcd]: https://github.com/coreos/etcd
[terraform]: https://terraform.io

[vagrant]: https://www.vagrantup.com
[virtualbox]: https://www.virtualbox.org/
[ansible]: http://www.ansible.com/

[badge-license]: https://img.shields.io/badge/license-Apache_2-green.svg
[badge-release]: https://img.shields.io/github/release/nlamirault/hyperion.svg
