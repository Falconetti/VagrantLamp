###########################
# Lamp Puppet Config      #
###########################
# OS          : Linux     #
# Database    : MySQL 5   #
# Web Server  : Apache 2  #
# PHP version : 5.3       #
###########################

include apache
include php
include mysql

$docroot = '/vagrant/www'

# Apache setup
class {'apache::mod::php': }

apache::vhost { 'local.lamp':
	priority => '20',
	port => '80',
	docroot => $docroot,
	configure_firewall => false,
}

a2mod { 'rewrite': ensure => present; }

# PHP Extensions
php::module { ['xdebug', 'mysql', 'curl', 'gd'] : 
    notify => [ Service['httpd'], ],
}
php::conf { [ 'pdo', 'pdo_mysql']:
    require => Package['php5-mysql'],
    notify  => Service['httpd'],
}

# MySQL Server
class { 'mysql::server':
  config_hash => { 'root_password' => 'l1k3ab0ss' }
}

mysql::db { 'pyrocms':
    user     => 'pyrocms',
    password => 'password',
    host     => 'localhost',
    grant    => ['all'],
    charset => 'utf8',
}

# Other Packages
$extras = ['vim', 'curl', 'phpunit']
package { $extras : ensure => 'installed' }


# Change IP-Tables to access mysql from outside

#firewall { "00002 accept localhost":
#  source => '127.0.0.1',
#  proto  => 'all',
#  action => 'accept',
#}
#exec { "iptables-save":
#  command => $operatingsystem ? {
#    "debian" => "/sbin/iptables-save > /etc/iptables/rules.v4",
#    /(RedHat|CentOS)/ => "/sbin/iptables-save > /etc/sysconfig/iptables",
#  },
#  refreshonly => true,
#  notify => Service["iptables"],
#}




# To Do:
# phpmyadmin
# mysqli
# ngix
# php5.29
# zendframework 1.6.
# zendframework 2.0
# backbone.js

# 