yumrepo { 'epel':
  descr    => 'Extra Packages for Enterprise Linux $releasever - $basearch',
  baseurl  => 'http://ftp.fau.de/epel/$releasever/$basearch',
  gpgkey   => 'http://ftp.fau.de/epel/RPM-GPG-KEY-EPEL-7',
  enabled  => 1,
  gpgcheck => 1,
}

yumrepo { 'ius':
  descr    => 'IUS Packages for Enterprise Linux $releasever - $basearch',
  baseurl  => 'https://repo.ius.io/$releasever/$basearch/',
  gpgkey   => 'https://repo.ius.io/RPM-GPG-KEY-IUS-7',
  enabled  => 1,
  gpgcheck => 1,
}

class { 'apache':
  default_vhost => false,
}

class { 'apache::mod::proxy':
  proxy_requests => 'Off',
}
class { 'apache::mod::proxy_fcgi':
}
class { 'apache::mod::fcgid':
  options => {
    'FcgidIPCDir'  => '/var/run/fcgidsock',
    'SharememPath' => '/var/run/fcgid_shm',
    'AddHandler'   => 'fcgid-script .fcgi  fcgi',
  },
}

apache::vhost { 'bacula_web':
  servername     => $facts['networking']['fqdn'],
  port           => '80',
  docroot        => '/var/www/html/bacula-web',
  manage_docroot => false,
  directories    => {
    path           => '/var/www/html/bacula-web',
    allow_override => ['All'],
    options        => [
      'FollowSymLinks',
      'MultiViews',
    ],
  },
}

class { 'php::globals':
  php_version => '7.4',
}

class { 'php':
  package_prefix => 'php74-',
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
