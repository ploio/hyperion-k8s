# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'hyperion'

  config.vm.box = "coreos-324.2.0"
  config.vm.box_url = "http://storage.core-os.net/coreos/amd64-usr/324.2.0/coreos_production_vagrant.box"

  config.vm.hostname = "Hyperion"
  config.vm.network :private_network, :ip => '10.1.3.5'
  config.vm.synced_folder ".", "/home/core/hyperion", type: "rsync"
  # FIX: Virtualbox 100%CPU using it
  #config.vm.synced_folder "/var/docker/hyperion", "/var/docker/hyperion", id: "core", :nfs => true,  :mount_options   => ['nolock,vers=3,udp']

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provider :virtualbox do |vb, override|
    # Fix docker not being able to resolve private registry in VirtualBox
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.memory = 1024
    vb.cpus = 1
    vb.name = "Hyperion"
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end


  # Kubernetes services

  config.vm.provision :file,
                      :source => "kubernetes/units/apiserver.service",
                      :destination => "/tmp/apiserver.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/apiserver.service /etc/systemd/system/apiserver.service",
                      :privileged => true
  # config.vm.provision :shell,
  #                     :inline => "fleetctl start /etc/systemd/system/apiserver.service",
  #                     :privileged => true

  config.vm.provision :file,
                      :source => "kubernetes/units/controller-manager.service",
                      :destination => "/tmp/controller-manager.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/controller-manager.service /etc/systemd/system/controller-manager.service",
                      :privileged => true
  # config.vm.provision :shell,
  #                     :inline => "fleetctl start /etc/systemd/system/controller-manager.service",
  #                     :privileged => true

  # Hyperion components

  config.vm.provision :file,
                      :source => "coreos/user-data",
                      :destination => "/tmp/vagrantfile-user-data"
  config.vm.provision :shell,
                      :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/",
                      :privileged => true

  config.vm.provision :file,
                      :source => "elasticsearch/hyperion-elasticsearch.service",
                      :destination => "/tmp/hyperion-elasticsearch.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/hyperion-elasticsearch.service /etc/systemd/system/hyperion-elasticsearch.service",
                      :privileged => true
  config.vm.provision :shell,
                      :inline => "fleetctl start /etc/systemd/system/hyperion-elasticsearch.service",
                      :privileged => true

  config.vm.provision :file,
                      :source => "monitoring-metrics/hyperion-monitoring-metrics.service",
                      :destination => "/tmp/hyperion-monitoring-metrics.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/hyperion-monitoring-metrics.service /etc/systemd/system/hyperion-monitoring-metrics.service",
                      :privileged => true
  config.vm.provision :shell,
                      :inline => "fleetctl start /etc/systemd/system/hyperion-monitoring-metrics.service",
                      :privileged => true

  config.vm.provision :file,
                      :source => "monitoring-ui/hyperion-monitoring-ui.service",
                      :destination => "/tmp/hyperion-monitoring-ui.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/hyperion-monitoring-ui.service /etc/systemd/system/hyperion-monitoring-ui.service",
                      :privileged => true
  config.vm.provision :shell,
                      :inline => "fleetctl start /etc/systemd/system/hyperion-monitoring-ui.service",
                      :privileged => true


end
