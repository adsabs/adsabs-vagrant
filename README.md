adsabs-vagrant
==============

Spin up a complete dev environment for working with the ADS application layer. Necessary backend components provided as docker containers within the virtualized environment.

Requirements: 

  * (Virtualbox provider) [Vagrant](http://vagrantup.com/) (>=1.4.3) + Virtualbox
  * (lxc provider) [Vagrant](http://vagrantup.com/) (==1.4.3) + [vagrant-lxc](https://github.com/fgrehm/vagrant-lxc) (0.7.0 or 0.8.0)


How-to:

  1. Choose provider:
         cp Vagrantfile.precise.[virtualbox|lxc] Vagrantfile
  2. Spin up the VM:
         vagrant up [--provider lxc]
  3. Log into the VM:
         vagrant ssh
  4. Provision application (requires protected github access+seekret password)
         cd /proj/ads/ && ./app_deploy_script.sh
  
The application is by default served by gunicorn+nginx on :8000. A flask devel server (:5000) may also be started via `shell.py`
