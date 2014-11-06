#Puppet manifest for minimal vagrant/docker

#Set global path for exec calls
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

class initialAptUpdate {
  exec {'update':
    command   => 'apt-get update && touch /etc/apt-updated-by-puppet',
    creates   => '/etc/.apt-updated-by-puppet',
  }
}
include initialAptUpdate

#Some "standard" apt packages
class aptPackages {
  package { ['git',
              'python-pip',
              'python-dev',
              'build-essential',
              'mtr',
              'locate',
              'nano',
              'host',
              'psmisc',
              'libpq-dev',
              'postgresql-client-9.3',
              'mongodb-clients',
              'libpng-dev',
              'libfreetype6-dev',
              'libxft-dev']:
    ensure    => installed,
    require   => Class['initialAptUpdate'];
  }
}
include aptPackages

exec {'bootstrap_pip':
  command   => 'pip install pip --upgrade',
  require   => Class['aptPackages'];
}

#Add some "standard" python packages
package { [ 'ipython',
            'psycopg2',
            'numpy',
            'matplotlib',
            'setuptools',
            'flask',
            'requests',
            'werkzeug',
            'SQLAlchemy',
            'alembic',
            'gunicorn']:
  ensure    => installed,
  provider  => 'pip',
  require   => Exec['bootstrap_pip'],
}
