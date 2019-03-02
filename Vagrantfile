# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "griff/nixos-18.09-x86_64"
  config.vm.box = "nixbox64"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  config.vm.hostname = "worknix"
  config.vm.network "private_network", ip: "172.16.16.16"
  config.vm.synced_folder ".", "/worknix"
  config.vm.synced_folder "../work_shared", "/work_shared"
 

  config.vm.provision :nixos, include: true, run: 'always', trace: true, verbose: true, inline: %{
      {config, pkgs, ...}: {
        #users.defaultUserShell = pkgs.fish;

        imports =
          [
            /etc/nixos/configuration.nix
            /worknix/nix/configuration.nix
          ];
      }
  }

  # Copy local user's SSH key to /home/vagrant/.ssh/id_rsa
  if File.exists?(File.join("#{Dir.home}/.ssh", "id_rsa"))
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      ssh_prv_key = File.read("#{Dir.home}/.ssh/id_rsa")
      s.inline = <<-SHELL
        mkdir -p /home/vagrant/.ssh/
        echo Provisioning public ssh key...
        [ -e /home/vagrant/.ssh/id_rsa.pub ] && rm /home/vagrant/.ssh/id_rsa.pub
        touch /home/vagrant/.ssh/id_rsa.pub
        echo "#{ssh_pub_key}" >> /home/vagrant/.ssh/id_rsa.pub

        echo Provisioning private ssh key...
        [ -e /home/vagrant/.ssh/id_rsa ] && rm /home/vagrant/.ssh/id_rsa
        touch /home/vagrant/.ssh/id_rsa
        echo "#{ssh_prv_key}" >> /home/vagrant/.ssh/id_rsa

        echo Provisioning of ssh keys completed [Success].
      SHELL
    end
  end



  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provider "virtualbox" do |vb|
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "8192"
     vb.cpus = 2
  end


end
