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
  pp_apache_mod_php = ''
  pp_php = ''
  if os[:family] == 'redhat' && os[:release].to_i != 8
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
    pp_apache_mod_php = <<-MANIFEST
      package_name => 'mod_php72u',
      php_version  => '7',
    MANIFEST
    php_version = "'7.2'"
    pp_php = <<-MANIFEST
      package_prefix => 'php72u-',
    MANIFEST
  end

  pp_setup = <<-MANIFEST
    #{pp_repo}
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
     #{pp_apache_mod_php}
    }
    class { '::php::globals':
      php_version => #{php_version},
    }
    class { '::php':
    #{pp_php}
      pear       => false,
      settings   => {
        'Date/date.timezone' => 'Europe/Berlin',
      },
      extensions => {
        gettext => {},
        gd      => {},
        json    => {},
        pdo     => {},
        pgsql   => {},
        posix   => {},
        mysqlnd => {},
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
