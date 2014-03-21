#Set global path for exec calls
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }


include nginx


vcsrepo {"/proj/ads/adsabs":
  ensure        => latest,
  provider      => git,
  user          => vagrant,
  source        => $adsabs_source,
  revision      => $adsabs_revision,
}

# vcsrepo {"/vagrant/adsabs-fabric": #WARNING: This actually returns success even if it can't clone due to auth problems!!!
#   ensure        => latest,
#   provider      => git,
#   user          => 'vsudilov',
#   source        => "https://github.com/asdabs/adsabs-fabric.git";
# }

exec {'pip_install_deps':
  command   => 'pip install -r requirements.txt',
  cwd       => '/proj/ads/adsabs/',
  require   => [Vcsrepo['/proj/ads/adsabs']],
  timeout   => 0,
}

nginx::resource::vhost { 'labs':
  ensure    => present,
  listen_port    => 8000,
  proxy     => 'http://gunicorn',
}

nginx::resource::upstream { 'gunicorn':
 ensure     => present,
 members    => [
   'unix:/tmp/gunicorn.socket fail_timeout=0', #module will append the ; automatically
 ],
}

file {'app_deploy_script':
  path      => "/proj/ads/app_deploy_script.sh",
  ensure    => present,
  owner     => vagrant,
  mode      => "700",
  content   => "
#!/bin/bash
git config --global credential.helper 'cache --timeout 120'
[ -d adsabs-fabric ] || git clone -b vss https://github.com/adsabs/adsabs-fabric.git
[ -d adsabs-stubdata ] || git clone https://github.com/adsabs/adsabs-stubdata.git
fab -f adsabs-fabric/fabfile local init
sudo fab -f adsabs-fabric/fabfile local run_production

#Let's remember to wrap this in either adsabs-fabric and/or adsabs-stubdata
mongorestore --host localhost --port 27017 /proj/ads/adsabs-stubdata/dump/mongo
"
}