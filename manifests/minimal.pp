#Puppet manifest for minimal vagrant/docker

#Set global path for exec calls
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

class initial_apt_update {
  exec {'update':
    command   => 'apt-get update && touch /etc/apt-updated-by-puppet',
    creates   => '/etc/.apt-updated-by-puppet',
  }

  exec {'add_keyserver':
    command   => 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10',
    creates   => '/etc/.apt-key-updated-by-puppet',
    require   =>  Exec['update'],
  }

  exec {'add_10gen':
    command   => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list",
    creates   => '/etc/apt/sources.list.d/10gen.list',
    require   => Exec['add_keyserver'],
  }

  exec {'final_update':
    command   => 'apt-get update',
    require   => Exec['add_10gen'],
  }
}

include initial_apt_update
package { ['git',
            'python-pip',
            'python-dev','build-essential','mongodb-10gen',
            'dnsmasq-base']:
  ensure    => installed,
  require   => Class['initial_apt_update'];
}

package { ['ipython','mtr','locate','nano','host','psmisc']: #Convenience packages, not mission critical
  ensure     => installed,
  require    => Class['initial_apt_update'];
}

exec {'remove_startup_services':
#  command => 'update-rc.d -f mongodb remove', #mongo doesn't use system-V init scripts
  command => "sed -i 's/ENABLE_MONGODB=\"yes\"/ENABLE_MONGODB=\"no\"/g' /etc/init/mongodb.conf",
  require => Package['mongodb-10gen'],
}

service {'mongodb':
  ensure => 'stopped',
  enable => false,
  require => Package['mongodb-10gen'],
}

exec {'bootstrap_pip':
  command   => 'pip install pip --upgrade',
  require   => Package['python-pip'];
}

