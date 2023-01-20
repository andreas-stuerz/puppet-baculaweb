yumrepo { 'epel':
  descr     => 'Extra Packages for Enterprise Linux $releasever - $basearch',
  metalink  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch&infra=$infra&content=$contentdir',
  gpgkey    => 'http://ftp.fau.de/epel/RPM-GPG-KEY-EPEL-8',
  enabled   => 1,
  gpgcheck  => 1,
}
yumrepo { 'remi':
  descr    => 'Remi RPM repository - $releasever/$basearch',
  mirrorlist  => 'http://cdn.remirepo.net/enterprise/$releasever/remi/$basearch/mirror',
  gpgkey   => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi2018',
  enabled  => 1,
  gpgcheck => 1,
  priority => 10,
}
package { 'php':
  ensure   => '7.4',
  provider => 'dnfmodule',
  enable_only => true
}

class { 'apache':
  default_vhost => false,
}

class { 'apache::mod::proxy':
  proxy_requests => 'Off',
}
class { 'apache::mod::proxy_fcgi': }

class { 'apache::mod::fcgid':
  options => {
    'FcgidIPCDir'  => '/var/run/fcgidsock',
    'SharememPath' => '/var/run/fcgid_shm',
    'AddHandler'   => 'fcgid-script .fcgi fcgi',
  },
}

apache::vhost { 'bacula_web':
  servername     => $::fqdn,
  port           => '80',
  docroot        => '/var/www/html/bacula-web',
  manage_docroot => false,
  directories    => {
    path     => '/var/www/html/bacula-web',
    allow_override => ['All'],
    options  => [
      'FollowSymLinks',
      'MultiViews'
    ]
  },
}

class { '::php::globals':
  php_version => '7.4',
}

class { '::php':
  package_prefix => 'php-',
  pear           => false,
  fpm            => true,
  settings       => {
    'Date/date.timezone' => 'Europe/Berlin',
  },
  extensions     => {
    gettext => {},
    gd      => {},
    json    => {},
    pdo     => {},
    pgsql   => {},
    mysqlnd => {},
    posix   => {},
  },
  notify         => Service['httpd'],
}

class { 'baculaweb': }
