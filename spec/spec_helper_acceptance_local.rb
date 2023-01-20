# frozen_string_literal: true

require 'puppet_litmus'
require 'singleton'
require 'tempfile'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

def setup_webserver
  pp_repo = ''
  php_version = 'undef'
  pp_php = ''
  sudo_package = 'sudo'
  php_extensions = <<-MANIFEST
    gd      => {},
    json    => {},
    pdo     => {},
    pgsql   => {},
    mysqlnd => {},
    posix   => {},
  MANIFEST

  if %r{debian|ubuntu}.match?(os[:family])
    php_extensions = <<-MANIFEST
      gd      => {},
      json    => {},
      pdo     => {},
      pgsql   => {},
      mysqlnd => {},
      posix   => {},
      sqlite3 => {},
    MANIFEST
  end

  if os[:family] == 'redhat' && os[:release].to_i == 7
    pp_repo = <<-MANIFEST
      yumrepo { 'epel':
        descr    => 'Extra Packages for Enterprise Linux $releasever - $basearch',
        baseurl  => 'http://ftp.fau.de/epel/$releasever/$basearch',
        gpgkey   => 'http://ftp.fau.de/epel/RPM-GPG-KEY-EPEL-#{os[:release].to_i}',
        enabled  => 1,
        gpgcheck => 1,
      }
      yumrepo { 'ius':
        descr    => 'IUS Packages for Enterprise Linux $releasever - $basearch',
        baseurl  => 'https://repo.ius.io/$releasever/$basearch/',
        gpgkey   => 'https://repo.ius.io/RPM-GPG-KEY-IUS-#{os[:release].to_i}',
        enabled  => 1,
        gpgcheck => 1,
      }
    MANIFEST

    php_version = "'7.4'"
    pp_php = <<-MANIFEST
      package_prefix => 'php74-',
    MANIFEST

    php_extensions = <<-MANIFEST
      gd        => {},
      json      => {},
      pdo       => {},
      pgsql     => {},
      mysqlnd   => {},
      process   => {},
    MANIFEST

  end

  if os[:family] == 'redhat' && os[:release].to_i == 8
    pp_repo = <<-MANIFEST
      yumrepo { 'epel':
        descr     => 'Extra Packages for Enterprise Linux $releasever - $basearch',
        metalink  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch&infra=$infra&content=$contentdir',
        gpgkey    => 'http://ftp.fau.de/epel/RPM-GPG-KEY-EPEL-#{os[:release].to_i}',
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
    MANIFEST
    php_version = "'7.4'"
    pp_php = <<-MANIFEST
      package_prefix => 'php-',
    MANIFEST

  end

  pp_setup = <<-MANIFEST
    #{pp_repo}
    $packages = [
      '#{sudo_package}',
    ]
    package { $packages:
      ensure => present,
    }

    class { 'apache':
      default_vhost => false,
    }

    class { 'apache::mod::proxy':
      proxy_requests => 'Off',
    }
    class { 'apache::mod::proxy_fcgi':}

    class { 'apache::mod::fcgid':
      options => {
        'FcgidIPCDir'  => '/var/run/fcgidsock',
        'SharememPath' => '/var/run/fcgid_shm',
        'AddHandler'   => 'fcgid-script .fcgi fcgi',
      },
    }

    apache::vhost { 'bacula_web':
      servername     => $::fqdn,
      port           => 80,
      docroot        => '/var/www/html/bacula-web/public',
      manage_docroot => false,
      directories    => [
        {
          path     => '/var/www/html/bacula-web/public',
          allow_override => ['All'],
          directoryindex => 'index.php',
          options  => [
            'FollowSymLinks',
            'MultiViews'
          ],
          addhandlers => {
            extensions => [
              '.inc',#{' '}
              '.php'
            ],
            handler => 'proxy:fcgi://127.0.0.1:9000/',
          }
        },
      ],
    }

    class { '::php::globals':
      php_version => #{php_version},
    }
    class { '::php':
    #{pp_php}
      pear       => false,
      fpm        => true,
      settings   => {
        'Date/date.timezone' => 'Europe/Berlin',
      },
      extensions => {
      #{php_extensions}
      },
      notify => Service['httpd'],
    }
  MANIFEST
  LitmusHelper.instance.apply_manifest(pp_setup, catch_failures: true)
end

RSpec.configure do |c|
  c.before :suite do
    LitmusHelper.instance.run_shell('puppet module install puppetlabs-apache')
    LitmusHelper.instance.run_shell('puppet module install puppet/php')
    setup_webserver
  end
end
