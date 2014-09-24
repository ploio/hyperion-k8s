# -*- mode: ruby -*-
# vi: set ft=ruby :

HYPERION_VERSION = "0.1.0"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# CoreOS setup
BOX_NAME = "coreos-410.0.0"
BOX_URL = "http://storage.core-os.net/coreos/amd64-usr/410.0.0/coreos_production_vagrant.box"

# Kubernetes
MASTER_CONF = File.join(File.dirname(__FILE__), "kubernetes/conf/master.yml")
MINION_CONF = File.join(File.dirname(__FILE__), "kubernetes/conf/minion.yml")
DISCOVERY_CONF = File.join(File.dirname(__FILE__), "kubernetes/conf/discovery.yml")
NUMBER_OF_MINIONS = (ENV['KUBERNETES_NUM_MINIONS'] || 2).to_i

# Network
BASE_IP_ADDR = "10.245.1"
DISCOVERY_IP_ADDR = "#{BASE_IP_ADDR}.10"
MASTER_IP_ADDR = "#{BASE_IP_ADDR}.100"
MINION_IP_ADDRS = (1..NUMBER_OF_MINIONS).collect { |i| BASE_IP_ADDR + ".#{i+100}" }

MOVE_USER_DATA_CMD = "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/"
ETCD_DISCOVERY_CMD = "sed -e \"s/%ETCD_DISCOVERY%/#{DISCOVERY_IP_ADDR}/g\" -i /tmp/vagrantfile-user-data"

BIN_PATH = File.join(File.dirname(__FILE__), "kubernetes/bin")

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  provision = ->(node, binaries) {
    node.vm.provision :shell, :inline => ETCD_DISCOVERY_CMD, :privileged => true
    node.vm.provision :shell, :inline => MOVE_USER_DATA_CMD, :privileged => true
    node.vm.provision :shell, :inline => "mkdir -p /opt/bin",  :privileged => true
    binaries.each do |file|
      next unless File.exist?("#{BIN_PATH}/#{file}")
      node.vm.provision :file, :source => "#{BIN_PATH}/#{file}", :destination => "/tmp/#{file}"
      node.vm.provision :shell, :inline => "mv /tmp/#{file} /opt/bin/#{file} && /usr/bin/chmod +x /opt/bin/#{file}",  :privileged => true
    end
  }

  # Discovery
  config.vm.define "discovery" do |discovery|
    discovery.vm.box = "#{BOX_NAME}"
    discovery.vm.box_url = "#{BOX_URL}"
    discovery.vm.hostname = "hyperion-discovery"
    discovery.vm.network :private_network, ip: DISCOVERY_IP_ADDR
    discovery.vm.provision :file, source: DISCOVERY_CONF, destination: "/tmp/vagrantfile-user-data"
    discovery.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
  end

  # Kubernetes master
  config.vm.define "master" do |master|
    master.vm.box = "#{BOX_NAME}"
    master.vm.box_url = "#{BOX_URL}"
    master.vm.hostname = "hyperion-master"
    master.vm.provision :file, :source => MASTER_CONF, :destination => "/tmp/vagrantfile-user-data"
    master.vm.provision :shell, :inline => "sed -e \"s/%MINION_IP_ADDRS%/#{MINION_IP_ADDRS.join(',')}/g\" -i /tmp/vagrantfile-user-data", :privileged => true
    master.vm.network "private_network", ip: MASTER_IP_ADDR
    provision.call(master, %w[flanneld kubecfg controller-manager apiserver scheduler])
  end

  # Kubernetes minion
  (1..NUMBER_OF_MINIONS).each do |i|
    config.vm.define "minion-#{i}" do |minion|
      minion.vm.box = "#{BOX_NAME}"
      minion.vm.box_url = "#{BOX_URL}"
      minion.vm.hostname = "hyperion-minion-#{i}"
      minion.vm.network :private_network, ip: MINION_IP_ADDRS[i-1]
      minion.vm.provision :file, :source => MINION_CONF, :destination => "/tmp/vagrantfile-user-data"
      provision.call(minion, %w[flanneld kubelet proxy])
    end
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  # Resolve issue with a specific Vagrant plugin by preventing it from updating.
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

end
