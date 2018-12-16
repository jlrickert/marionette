# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$debian_script = <<-SCRIPT
usermod -a -G users vagrant
apt-get -y update && apt-get install python3
SCRIPT

$arch_script = <<-SCRIPT
usermod -a -G users vagrant
pacman -Sy --noconfirm --needed glibc python
SCRIPT

$arch_box = "terrywang/archlinux"
$debian_box = "debian/stretch64"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "master-server" do |controller|
    config.vm.box = $debian_box
    controller.vm.network "private_network", ip: "192.168.77.20"
    controller.vm.provision "shell", inline: $debian_script
  end

  config.vm.define "worker1" do |controller|
    config.vm.box = $debian_box
    controller.vm.network "private_network", ip: "192.168.77.21"
    controller.vm.provision "shell", inline: $debian_script
  end

  config.vm.define "worker2" do |controller|
    config.vm.box = $debian_box
    controller.vm.network "private_network", ip: "192.168.77.22"
    controller.vm.provision "shell", inline: $debian_script
  end

  config.vm.define "laptop" do |laptop|
    laptop.vm.box = $arch_box
    laptop.vm.network "private_network", ip: "192.168.77.10"
    laptop.vm.provision "shell", inline: $arch_script
    laptop.vm.provider 'virtualbox' do |vb|
      # vb.gui = true
    end
  end

  config.vm.define "desktop" do |desktop|
    desktop.vm.box = $arch_box
    desktop.vm.network "private_network", ip: "192.168.77.11"
    desktop.vm.provision "shell", inline: $arch_script
    desktop.vm.provider 'virtualbox' do |vb|
      # vb.gui = true
    end

    desktop.vm.provision "ansible" do |ansible|
      ansible.limit = "all"
      ansible.playbook = "playbooks/site.yml"
      ansible.become = true
      ansible.host_vars = {
        "laptop" => { "workstation_type" => "laptop" },
        "desktop" => { "workstation_type" => "desktop" }
      }
      ansible.groups = {
        "master" => ["master-server"],
        "worker" => ["worker1", "worker2"],
        "workstation" => ["desktop", "laptop"],
      }
    end
  end
end
