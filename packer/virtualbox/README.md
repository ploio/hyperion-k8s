# Packer templates for Virtualbox

This project contains [Packer][] templates to help you deploy [hyperion][] on [Virtualbox][/].

## Prerequisites

* Virtualbox

## Configure

## Deploy

Build the image

    $ export ATLAS_TOKEN="xxx"
    $ packer build hyperion.json

Publish to [Atlas][] :

    $ packer push \
         --name hyperion/core -token=${ATLAS_TOKEN} \
         hyperion.json


[Packer]: https://www.packer.io/
[Virtualbox]: https://www.virtualbox.org/
[Atlas]: https://atlas.hashicorp.com/hyperion

[hyperion]: http://github.com/portefaix/hyperion
