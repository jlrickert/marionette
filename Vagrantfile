# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "server" do |controller|
    controller.vm.box = "debian/stretch64"
    controller.vm.network "private_network", ip: "192.168.77.20"
  end

  config.vm.define "laptop" do |laptop|
    laptop.vm.box = "arch"
    laptop.vm.network "private_network", ip: "192.168.77.10"
  end

  config.vm.define "desktop" do |desktop|
    desktop.vm.box = "arch"
    desktop.vm.network "private_network", ip: "192.168.77.11"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.limit = "all"
    ansible.playbook = "site.yml"
    ansible.host_vars = {
      "laptop" => { "workstation_type" => "laptop" },
      "desktop" => { "workstation_type" => "desktop" }
    }
    ansible.groups = {
      "controller" => ["server"],
      "workstation" => ["desktop", "laptop"],
    }
  end
end
