# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

DEBIAN_SCRIPT = <<-SCRIPT
usermod -a -G users vagrant
apt-get -y update && apt-get install python3
SCRIPT

ARCH_SCRIPT = <<-SCRIPT
usermod -a -G users vagrant
pacman -Sy --noconfirm --needed glibc python
SCRIPT

ARCH_BOX = "terrywang/archlinux"
DEBIAN_BOX = "debian/stretch64"

def configure_debian_box(config, ip)
  config.vm.box = DEBIAN_BOX
  config.vm.network "private_network", ip: ip
  config.vm.provision :shell, inline: DEBIAN_SCRIPT
  config.vm.provider :virtualbox do |vb, override|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 1
  end
end

def configure_arch_box(config, ip)
  config.vm.box = ARCH_BOX
  config.vm.network :private_network, ip: ip
  config.vm.provision :shell, inline: ARCH_SCRIPT
  config.vm.provider :virtualbox do |vb, override|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 1
  end
end

def get_hosts()
  hosts = [
    {
      :name => "desktop",
      :group => "workstations",
      :vars => { "workstation_type" => "desktop"},
    },

    {
      :name => "laptop",
      :group => "workstations",
      :vars => { "workstation_type" => "laptop"},
    },

    { :name => "kube-master1", :group => "kube-masters" }
  ]
  (1..2).each do |i|
    hosts.push(
      {
        :name => "kube-node#{i}",
        :group => "kube-nodes",
      })
  end
  hosts
end

def get_groups_from(hosts)
  groups = { "kube-cluster:children" => ["kube-masters", "kube-nodes"] }
  for host in hosts do
    if groups.has_key?(host[:group])
      groups[host[:group]].push(host[:name])
    else
      groups[host[:group]] = [host[:name]]
    end
  end
  groups
end

def get_host_vars_from(hosts)
  host_vars = {}
  for host in hosts do
    if host.has_key?(:vars)
      host_vars[host[:name]] = host[:vars]
    end
  end
  host_vars
end

def configure_hosts(config, hosts)
  groups = get_groups_from(hosts)
  host_vars = get_host_vars_from(hosts)

  ip_acc = 10
  n = hosts.length
  (1..n).each do |machine_id|
    host = hosts[machine_id - 1]
    config.vm.define host[:name] do |node|
      ip = "192.168.77.#{ip_acc}"
      if host[:group] == "workstations"
        configure_arch_box(node, ip)
      else
        configure_debian_box(node, ip)
      end

      if machine_id == n
        node.vm.provision "ansible" do |ansible|
          ansible.host_vars = host_vars
          ansible.groups = groups
          ansible.limit = "all"
          ansible.playbook = "playbooks/site.yml"
          ansible.host_key_checking = false
        end
      end
    end
    ip_acc += 1
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  hosts = get_hosts()
  config.vm.provider "virtualbox"
  configure_hosts(config, hosts)
end
