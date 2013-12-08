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
file { '/deploy/.bashrc':
      ensure => 'present',
      owner => user-deploy,
      mode    => 0640,
      group => user-deploy,
      content => "alias ll='ls-l'; alias ne='emacs -nw'",     
} ->
file { '/deploy/.forward':
      ensure => 'present',
      owner => user-deploy,
      mode    => 0640,
      group => user-deploy,
      content => "minette.alexandre+dedicated@gmail.com",     
} ->
file {'/deploy/.ssh':
  mode => 700,
  ensure  => 'directory',  
  owner => 'user-deploy',
  group => user-deploy  
} -> exec { "ssh-keygen":
  command => "ssh-keygen -t rsa -C 'minette.alexandre+dedicated@gmail.com' -f /deploy/.ssh/id_rsa -P ''",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  creates => '/deploy/.ssh/id_rsa'
} ->
file{'/deploy/.ssh/id_rsa':
  mode => 0600,
  owner => user-deploy,
  group => user-deploy
} ->
file {'/deploy/.ssh/id_rsa.pub':
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
exec { "setfacl -m g:user-deploy:rwx /etc/apache2/site-enabled/":
  command => "setfacl -m g:user-deploy:rwx /etc/apache2/site-enabled/",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
} 

exec { "setfacl -m g:user-deploy:rwx /etc/apache2/site-available/":
  command => "setfacl -m g:user-deploy:rwx /etc/apache2/site-available/",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
} 

