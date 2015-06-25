# -*- mode: ruby -*-
# vi: set ft=ruby :

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

  config.vm.provider "virtualbox" do |vb|
    vb.check_guest_additions = false
    vb.functional_vboxsf = false
    # vb.customize ["modifyvm", :id, "--name", "hyperion-master", "--memory", "512"]
  end

  config.vm.define "master" do |master|
    # master.vm.hostname = "hyperion-master"
    master.vm.network :private_network, ip: master_ip_addr
  end

  (1..$number_of_minions).each do |i|
    config.vm.define "minion-#{i}" do |minion|
      minion.vm.network :private_network, ip: minion_ip_addrs[i-1]
    end
  end

  config.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/master.playbook"
      ansible.inventory_path = "ansible/hyperion"
      ansible.limit = "all"
      ansible.verbose = "vv"
  end

  config.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/master.playbook"
      ansible.inventory_path = "ansible/hyperion"
      ansible.limit = "all"
      ansible.verbose = "vv"
  end

end
