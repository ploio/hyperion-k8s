# Terraform templates for Openstack

This project contains [Terraform][] templates to help you deploy [hyperion-k8s][] on [Openstack][].

## Prerequisites

* An Openstack Cloud
* An Account, project and relevant access on your openstack cloud.

## Configure

The available variables that can be configured are:

* **openstack_access_key**: Openstack username.
* **openstack_secret_key**: Openstack Password.
* **openstack_tenant_name**: The Tenant/Project name in Openstack.
* **openstack_key_name**: The name given to the SSH key which will be uploaded for use by the instances.
* **pub_key**: The actual contents of rsa_id.pub to upload as the public key.
* **pvt_key**: Path to the SSH private key file (Stays local. Used for provisioning.)
* **openstack_ssh_user**: SSH user (default ubuntu)
* **openstack_keystone_uri**: The Keystone API URL

Setup your informations :

    $ export OPENSTACK_ACCESS_KEY="xxxx"
    $ export OPENSTACK_SECRET_KEY="xxxx"
    $ ...

## Deploy

Deploy your cluster

    $ terraform apply \
            -var "pub_key=$HOME/.ssh/id_rsa.pub" \
            -var "pvt_key=$HOME/.ssh/id_rsa" \
            -var "openstack_access_key=$(OPENSTACK_ACCESS_KEY)"
            -var "openstack_secret_key=$(OPENSTACK_SECRET_KEY)"
            [...]


## Destroy

Destroy the cluster :

    $ terraform destroy \
        -var "openstack_access_key=$(OPENSTACK_ACCESS_KEY)"
        -var "openstack_secret_key=$(OPENSTACK_SECRET_KEY)"
        [...]

## Updating




[Terraform]: https://www.terraform.io/
[Openstack]: https://www.openstack.org

[hyperion]: http://github.com/portefaix/hyperion-k8s
