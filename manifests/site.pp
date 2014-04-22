#Puppet manifest for ads appservers

#Set global path for exec calls
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

stage {'first':
  before  => Stage['main'],
}

stage {'last':
  require  => Stage['main'],
}


class {
  'stage_1': stage  => first;
  'stage_2': stage  => last;
}

class stage_2 {

  exec { 'provision': #Can't call newly bootstrapped modules from within the same puppet process!
    command     => 'puppet apply /vagrant/manifests/stage2.pp',
    timeout     => 0;
  }

}

class stage_1 {

  user {'vagrant':
    ensure      => present,
  }

  file {"/proj/":
    ensure      => directory,
    recurse     => false,
    owner       => vagrant,
    group       => vagrant,
    require     => User['vagrant'],
  }


  file {"/proj/ads/":
    ensure      => directory,
    recurse     => false,
    owner       => vagrant,
    group       => vagrant,
    require     => File["/proj/"]; #Alternatvively, use `exec {'mkdir -p /path/to/foo/': }`
  }

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

    exec {'add_puppetlabs_repo':
      command   => 'wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb --no-check-certificate && dpkg -i puppetlabs-release-precise.deb',
      cwd       => '/root',
      creates   => '/root/puppetlabs-release-precise.deb',
    }

    package {'puppet':
      ensure    => latest,
      require   => Exec['final_update'],
    }
#RUN wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb --no-check-certificate
#RUN dpkg -i puppetlabs-release-precise.deb
#RUN apt-get install -y puppet

    exec {'final_update':
      command   => 'apt-get update',
      require   => [Exec['add_10gen'],Exec['add_puppetlabs_repo'],]
    }

  }
  
  include initial_apt_update
  package { ['rubygems','ruby-dev','git',
              'nginx','python-pip','libmysqlclient-dev',
              'python-dev','build-essential','libxml2-dev','libxslt-dev','mongodb-10gen',
              'dnsmasq-base']:
    ensure    => installed,
    require   => Class['initial_apt_update'];
  }

  package { ['ipython','mtr','locate','nano','host','psmisc']: #Convenience packages, not mission critical
    ensure     => installed,
    require    => Class['initial_apt_update'];
  }

  package { 'librarian_puppet':
    name      => 'librarian-puppet',
    ensure    => installed,
    provider  => gem,
    require   => Package['rubygems']
  }

  #We will install modules to /etc/puppet due to inconvience of vagrant-lxc user permission problems
  file {'/etc/puppet/Puppetfile':
    ensure    => link,
    target    => '/vagrant/Puppetfile';
  }

  exec {'remove_startup_services':
    command => 'update-rc.d -f mongodb remove',
    require => Package['mongodb-10gen'],
  }

  exec { 'librarian_puppet_install':
    command   => 'librarian-puppet install',
    cwd       => '/etc/puppet',
    environment => 'HOME=/root', #Must be specified or librarian-puppet will break
    user      => root,
    require   => [Package['librarian_puppet'],File['/etc/puppet/Puppetfile']];
  }

  exec {'bootstrap_pip':
    command   => 'pip install pip --upgrade',
    require   => [Package['python-pip'],Package['git'],Package['libmysqlclient-dev'],
                  Package['python-dev'],Package['build-essential'],Package['libxslt-dev'],
                  Package['libxml2-dev']];
  }

  package {['gunicorn','fabric']: 
    provider  => pip,
    ensure    => installed,
    require   => Exec['bootstrap_pip'];
  }
}
