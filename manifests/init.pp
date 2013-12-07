user { 'user-deploy':
    ensure  => 'present',
    comment => 'deploy',
    home    => '/deploy',
    shell   => '/bin/bash',
}

file {'/deploy':
      ensure  => 'directory',
      mode    => 0640,
      owner => user-deploy,
      group => user-deploy,
} ->
file { '/deploy/.forward':
      ensure => 'present',
      owner => user-deploy,
      mode    => 0640,
      group => user-deploy,
      content => "minette.alexandre+dedicated@gmail.com",     
} -> exec { "ssh-keygen":
  command => "ssh-keygen -t rsa -C 'minette.alexandre+dedicated@gmail.com' -f /deploy/id_rsa -P ''",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  creates => '/deploy/id_rsa'
} ->
file{'/deploy/id_rsa':
  mode => 0640,
  owner => user-deploy,
  group => user-deploy
} ->
file {'/deploy/id_rsa.pub':
  mode => 0640,
  owner => user-deploy,
  group => user-deploy
}


package { "acl":
  ensure => installed,
} -> file {'/var/www':
      ensure  => 'directory',
} ->
exec { "setfacl -m g:user-deploy:rwx /var/www/":
  command => "setfacl -m g:user-deploy:rwx /var/www/",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
} 

