# Terraform templates for DigitalOcean

This project contains [Terraform][] templates to help you deploy [hyperion][] on [DigitalOcean][].

## Prerequisites

* A DigitalOcean account
* A DigitalOcean API Token
* A DigitalOcean Password-less SSH Key
* A DigitalOcean Region supporting private networking (all regions except sfo1)

## Configure

The available variables that can be configured are:

* **do_token**: Digital Ocean API token
* **pub_key**: SSH public key id. Key ID of your uploaded SSH key.
* **pvt_key**: Path to the SSH private key file
* **ssh_fingerprint**: fingerprint of the SSH public key

Copy and renamed *terraform.tfvars.example* to *terraform.tfvars*.
Follow the instructions in the comments of the terraform.tfvars.example and
variables.tf file.

## Deploy

Deploy your cluster

    $ terraform apply --var-file=terraform.tfvars

## Destroy

Destroy the cluster :

    $ terraform destroy --var-file=terraform.tfvars

## Updating



[Terraform]: https://www.terraform.io/
[DigitalOcean]: https://www.digitalocean.com/

[hyperion]: http://github.com/nlamirault/hyperion
