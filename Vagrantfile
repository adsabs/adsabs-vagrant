# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-14.04_amd64-adsabs-vagrant-virtualbox"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
   config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1000
    v.cpus = 2
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

      config.vm.network :forwarded_port, guest: 80, host: 8080     #Forward guest_port:host_port
      config.vm.network :forwarded_port, guest: 5000, host: 5000   #Standard python-Flask devel server

      config.vm.network :forwarded_port, guest: 8983, host: 8983   #Default solr port
      config.vm.network :forwarded_port, guest: 27017, host: 27017 #Default mongo port
      config.vm.network :forwarded_port, guest: 5432, host: 5432   #Default postgresql port
      config.vm.network :forwarded_port, guest: 5672, host: 5672   #Default rabbitmq server
      config.vm.network :forwarded_port, guest: 15672, host: 15672 #Default rabbitmq admin interface
      

      #This allows the guest machine to access the host directly via the IP address 192.168.50.1
      #If you want to connect to solr:9000 from the guest, do the following:
      # set up tunnels on host
      # set up tunnels on VM to host (ssh -N -f -L 9000:localhost:9000 user@192.168.50.1)
      # localhost:9000 on both host and VM now point to solr:9000
     # config.vm.network "private_network", ip: "192.168.50.4"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
   #config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
    config.vm.synced_folder ".", "/vagrant/adsabs-vagrant"
#    config.vm.synced_folder "~/ADSimportpipeline/", "/vagrant/ADSimportpipeline"
#    config.vm.synced_folder "~/adsws/", "/vagrant/adsws"
#    config.vm.synced_folder "~/adsabs-webservices-blueprint", "/vagrant/adsabs-webservices-blueprint"


  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "minimal.pp"
  end

  #Builds the mongo image, but does not run it.
  #This will ensure that Vagrant installs Docker.
  config.vm.provision "docker" do |docker|
    docker.build_image "/vagrant/dockerfiles/mongo",
      args: "-t adsabs/mongo"
  end

end
