#!/bin/bash

apt-get update
apt-get dist-upgrade
# install curl to fix broken wget while retrieving content from secured sites
apt-get -y install curl
