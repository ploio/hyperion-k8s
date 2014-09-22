# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'hyperion'

  config.vm.box = "coreos-410.0.0"
  config.vm.box_url = "http://storage.core-os.net/coreos/amd64-usr/410.0.0/coreos_production_vagrant.box"

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


  # Install services

  config.vm.provision :file,
                      :source => "kubernetes/units/download-kubernetes.service",
                      :destination => "/tmp/download-kubernetes.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/download-kubernetes.service /etc/systemd/system/download-kubernetes.service",
                      :privileged => true

  config.vm.provision :file,
                      :source => "kubernetes/units/apiserver.service",
                      :destination => "/tmp/apiserver.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/apiserver.service /etc/systemd/system/apiserver.service",
                      :privileged => true

  config.vm.provision :file,
                      :source => "kubernetes/units/controller-manager.service",
                      :destination => "/tmp/controller-manager.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/controller-manager.service /etc/systemd/system/controller-manager.service",
                      :privileged => true

  config.vm.provision :file,
                      :source => "kubernetes/units/kubelet.service",
                      :destination => "/tmp/kubelet.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/kubelet.service /etc/systemd/system/kubelet.service",
                      :privileged => true

  config.vm.provision :file,
                      :source => "kubernetes/units/proxy.service",
                      :destination => "/tmp/proxy.service"
  config.vm.provision :shell,
                      :inline => "mv /tmp/proxy.service /etc/systemd/system/proxy.service",
                      :privileged => true

  # SystemD services

  config.vm.provision :shell,
                      :inline => "systemctl start etcd",
                      :privileged => true

  config.vm.provision :shell,
                      :inline => "systemctl start download-kubernetes",
                      :privileged => true

  config.vm.provision :shell,
                      :inline => "systemctl start apiserver",
                      :privileged => true
  config.vm.provision :shell,
                      :inline => "systemctl start controller-manager",
                      :privileged => true
  config.vm.provision :shell,
                      :inline => "systemctl start kubelet",
                      :privileged => true
  config.vm.provision :shell,
                      :inline => "systemctl start proxy",
                      :privileged => true


end
