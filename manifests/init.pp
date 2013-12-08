

user { 'www-data':
    ensure  => 'present',
    home    => '/deploy',
    shell   => '/bin/bash',
}

file {'/deploy':
      ensure  => 'directory',
      mode    => 0640,
      owner => www-data,
      group => www-data,
} ->
file { '/deploy/.bashrc':
      ensure => 'present',
      owner => www-data,
      mode    => 0640,
      group => www-data,
      content => "alias ll='ls-l'; alias ne='emacs -nw'",     
} ->
file { '/deploy/.forward':
      ensure => 'present',
      owner => www-data,
      mode    => 0640,
      group => www-data,
      content => "minette.alexandre+dedicated@gmail.com",     
} ->
file {'/deploy/.ssh':
  mode => 700,
  ensure  => 'directory',  
  owner => 'www-data',
  group => www-data  
} -> exec { "ssh-keygen":
  command => "ssh-keygen -t rsa -C 'minette.alexandre+dedicated@gmail.com' -f /deploy/.ssh/id_rsa -P ''",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  creates => '/deploy/.ssh/id_rsa'
} ->
file{'/deploy/.ssh/id_rsa':
  mode => 0600,
  owner => www-data,
  group => www-data
} ->
file {'/deploy/.ssh/id_rsa.pub':
  mode => 0640,
  owner => www-data,
  group => www-data
}


package { "acl":
  ensure => installed,
} -> file {'/var/www':
      ensure  => 'directory',
} ->
exec { "setfacl -m g:www-data:rwx /var/www/":
  command => "setfacl -m g:www-data:rwx /var/www/",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
}
exec { "setfacl -m g:www-data:rwx /etc/apache2/sites-enabled/":
  command => "setfacl -m g:www-data:rwx /etc/apache2/sites-enabled/",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
} 

exec { "setfacl -m g:www-data:rwx /etc/apache2/sites-available/":
  command => "setfacl -m g:www-data:rwx /etc/apache2/sites-available/",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
} 

exec { "rm -f /etc/apache2/sites-available/*default.conf":
  command => "rm -f /etc/apache2/sites-available/*default.conf",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  #refreshonly => true,
}

exec { "rm -f /etc/apache2/sites-enabled/*default.conf":
  command => "rm -f /etc/apache2/sites-enabled/*default.conf",
  path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  #refreshonly => true,
}
