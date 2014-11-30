# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# -*- mode: ruby -*-
# # vi: set ft=ruby :

require "fileutils"

$number_of_minions = 3

# CoreOS setup
BOX_NAME = "coreos-410.0.0"
BOX_URL = "http://storage.core-os.net/coreos/amd64-usr/410.0.0/coreos_production_vagrant.box"

enable_serial_logging = false

$base_ip_addr = "10.245.1"

def discovery_ip_addr; "#{$base_ip_addr}.10"; end
def master_ip_addr; "#{$base_ip_addr}.100"; end
def minion_ip_addrs; (1..$number_of_minions).collect { |i| $base_ip_addr + ".#{i+100}" }; end

discovery_config_path = File.join(File.dirname(__FILE__),
                                  "config/discovery.yml")
master_config_path = File.join(File.dirname(__FILE__),
                               "config/master.yml")
minion_config_path = File.join(File.dirname(__FILE__),
                               "config/minion.yml")
bin_path = File.join(File.dirname(__FILE__), "bin")

Vagrant.require_version ">= 1.6.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "#{BOX_NAME}"
  config.vm.box_url = "#{BOX_URL}"

  # Enable NFS for sharing the host machine into the coreos-vagrant VM.
  # config.vm.synced_folder ".", "/home/core/share", id: "core", nfs: true, mount_options: ["nolock,vers=3,udp"]
  config.nfs.functional = false

  config.vm.provider "virtualbox" do |vb|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    vb.check_guest_additions = false
    vb.functional_vboxsf = false

    # Fix docker not being able to resolve private registry in VirtualBox
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Resolve issue with a specific Vagrant plugin by preventing it from updating.
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  configure_node = ->(options = {}) {
    node        = options[:node]        || nil
    vm_name     = options[:vm_name]     || nil
    ip_addr     = options[:ip_addr]     || nil
    config_path = options[:config_path] || nil
    binaries    = options[:binaries]    || []
    commands    = options[:commands]    || []

    if enable_serial_logging
      logdir = File.join(File.dirname(__FILE__), "log")
      FileUtils.mkdir_p(logdir)

      serialFile = File.join(logdir, "#{vm_name}-serial.txt")
      FileUtils.touch(serialFile)

      config.vm.provider :virtualbox do |vb, override|
        vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
        vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
      end

      config.vm.provider :vmware_fusion do |v, override|
        v.vmx["serial0.present"]     = "TRUE"
        v.vmx["serial0.fileType"]    = "file"
        v.vmx["serial0.fileName"]    = serialFile
        v.vmx["serial0.tryNoRxLoss"] = "FALSE"
      end
    end

    node.vm.hostname = vm_name if vm_name != nil
    node.vm.network :private_network, ip: ip_addr if ip_addr != nil
    node.vm.provision :file,
                      source: config_path,
                      destination: "/tmp/vagrantfile-user-data" if config_path != nil

    # Substitute the placeholders.
    commands << "sed -e \"s/%discovery_ip_addr%/#{discovery_ip_addr}/g\" -i /tmp/vagrantfile-user-data" if vm_name != "discovery"

    # Move the cloud-config file to its expected place.
    commands << "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/"

    # Copy the binaries.
    commands << "mkdir -p /opt/bin" if binaries.size > 0
    binaries.each do |file|
      next unless File.exist?("#{bin_path}/#{file}")
      node.vm.provision :file,
                        source: "#{bin_path}/#{file}",
                        destination: "/tmp/#{file}"
      commands << "mv /tmp/#{file} /opt/bin/#{file}"
      commands << "/usr/bin/chmod +x /opt/bin/#{file}"
    end

    # Run the commands.
    node.vm.provision :shell,
                      inline: commands.join(" && "),
                      privileged: true
  }

  config.vm.define "discovery" do |discovery|
    configure_node.call(
      node: discovery,
      vm_name: "hyperion-discovery",
      ip_addr: discovery_ip_addr,
      config_path: discovery_config_path
    )
  end

  config.vm.define "master" do |master|
    # master.vm.network :forwarded_port, guest: 4001, host: 4001
    configure_node.call(
      node: master,
      vm_name: "hyperion-master",
      ip_addr: master_ip_addr,
      config_path: master_config_path,
      binaries: %w[flanneld kubecfg controller-manager apiserver scheduler],
      commands: ["sed -e \"s/%minion_ip_addrs%/#{minion_ip_addrs.join(',')}/g\" -i /tmp/vagrantfile-user-data"]
    )
  end

  (1..$number_of_minions).each do |i|
    config.vm.define "minion-#{i}" do |minion|
      configure_node.call(
        node: minion,
        vm_name: "hyperion-minion-#{i}",
        ip_addr: minion_ip_addrs[i-1],
        config_path: minion_config_path,
        binaries: %w[flanneld kubelet proxy]
      )
    end
  end
end
