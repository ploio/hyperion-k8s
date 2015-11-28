# Terraform templates for Google Cloud

This project contains [Terraform][] templates to help you deploy [hyperion-k8s][] on [Google cloud][].

## Prerequisites

* A Google Cloud account
* A Google Compute Engine project
* A Google Compute Engine account file
* A Google Compute Engine Password-less SSH Key

## Configure

The available variables that can be configured are:

* **gce_account_file**: Path to the JSON file used to describe your account credentials, downloaded from Google Cloud Console
* **gce_project**: The name of the project to apply any resources to
* **gce_ssh_user**: SSH user
* **pvt_key_file**: Path to the SSH private key file
* **gce_region**: The region to operate under (default us-central1)
* **gce_zone**: The zone that the machines should be created in (default us-central1-a)
* **gce_ipv4_range**: The IPv4 address range that machines in the network are assigned to, represented as a CIDR block (default 10.0.0.0/16)
* **gce_image**: The name of the image to base the launched instances (default ubuntu-1404-trusty-v20141212)

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
[Google cloud]: https://cloud.google.com

[hyperion-k8s]: http://github.com/portefaix/hyperion-k8s
