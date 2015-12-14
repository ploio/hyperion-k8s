# Packer templates for DigitalOcean

This project contains [Packer][] templates to help you deploy [hyperion][] on [DigitalOcean][].

## Prerequisites

* A Digital Ocean account

## Configure

The available variables that can be configured are:

* **api_token**: The client TOKEN to use to access your account
* **image**: The name (or slug) of the base image to use
* **region**: The name (or slug) of the region to launch the droplet in
* **size**: The name (or slug) of the droplet size to use

Edit *settings.json* and setup your data.

## Deploy

Build the image

    $ packer build --var-file=settings.json hyperion.json



[Packer]: https://www.packer.io/
[DigitalOcean]: https://www.digitalocean.com/

[hyperion]: http://github.com/portefaix/hyperion
