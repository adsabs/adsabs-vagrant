adsabs-vagrant
==============

Spin up a dev environment for working with ADS services. Provisions a VM with 2 cpus and 1GB RAM running Ubuntu 14.04. The VM is provisioned to install some useful packages via apt and pip.

Requirements: 

  * [Vagrant](http://vagrantup.com/) (>=1.5+), uses Virtualbox provider
  * Virtualbox(https://www.virtualbox.org/)

How-to:

  1. Configure any useful sync'd folders or forwarded ports in `Vagrantfile`

  1. Spin up the VM:

         vagrant up

  1. Log into the VM:

         vagrant ssh

  1. Clone your repos, follow each repo's setup instructions in this sandboxed environment, develop