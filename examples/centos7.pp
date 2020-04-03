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

apache::vhost { 'bacula_web':
  servername     => $::fqdn,
  port           => '80',
  docroot        => '/var/www/html/bacula-web',
  manage_docroot => false,
  directories    => {
    path     => '/var/www/html/bacula-web',
    override => ['All'],
    options  => [
      'FollowSymLinks',
      'MultiViews'
    ]
  },
}

class { 'apache::mod::php':
  package_name => 'mod_php72u',
  php_version  => '7',

}

class { '::php::globals':
  php_version => '7.2',
}

class { '::php':
  package_prefix => 'php72u-',
  pear           => false,
  settings       => {
    'Date/date.timezone' => 'Europe/Berlin',
  },
  extensions     => {
    gettext => {},
    gd      => {},
    json    => {},
    pdo     => {},
    pgsql   => {},
    posix   => {},
    mysqlnd => {},
  },
  notify         => Service['httpd'],
}

class { 'baculaweb': }
