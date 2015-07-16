# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright 2015 Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require "fileutils"

$number_of_minions = 2

BOX_NAME = "vivid64"
BOX_URL = "http://cloud-images.ubuntu.com/vagrant/vivid/current/vivid-server-cloudimg-amd64-vagrant-disk1.box"
# BOX_NAME = "utopic64"
# BOX_URL = "http://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box"

$base_ip_addr = "10.245.1"
def master_ip_addr; "#{$base_ip_addr}.100"; end
def minion_ip_addrs; (1..$number_of_minions).collect { |i| $base_ip_addr + ".#{i+100}" }; end

bin_path = File.join(File.dirname(__FILE__), "bin")
services_path = File.join(File.dirname(__FILE__), "units")
conf_path = File.join(File.dirname(__FILE__), "conf")

Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "#{BOX_NAME}"
  config.vm.box_url = "#{BOX_URL}"

  # By default, Vagrant 1.7+ automatically inserts a different
  # insecure keypair for each new VM created. The easiest way
  # to use the same keypair for all the machines is to disable
  # this feature and rely on the legacy insecure key.
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |vb|
    vb.check_guest_additions = false
    vb.functional_vboxsf = false
    # vb.customize ["modifyvm", :id, "--name", "hyperion-master", "--memory", "512"]
  end

  config.vm.define "master" do |master|
    # master.vm.hostname = "hyperion-master"
    master.vm.network :private_network, ip: master_ip_addr
  end

  # config.vm.provision :ansible do |ansible|
  #   ansible.playbook = "ansible/master.yml"
  #   ansible.inventory_path = "ansible/hyperion"
  #   ansible.limit = "all"
  #   ansible.verbose = "vv"
  # end

  (1..$number_of_minions).each do |i|
    config.vm.define "minion-#{i}" do |minion|
      minion.vm.network :private_network, ip: minion_ip_addrs[i-1]
    end
  end

  # config.vm.provision :ansible do |ansible|
  #   ansible.playbook = "ansible/minions.yml"
  #   ansible.inventory_path = "ansible/hyperion"
  #   ansible.limit = "all"
  #   ansible.verbose = "vv"
  # end


end
