# baculaweb

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
  * [Optional Setup Requirements](#optional-setup-requirements)
  * [Beginning with baculaweb](#beginning-with-baculaweb)
3. [Usage](#usage)
  * [Install and enable baculaweb](#install-and-enable-baculaweb)
  * [Configure one or more bacula catalog databases (mysql, pgsql or sqlite) ***Required***](#configure-one-or-more-bacula-catalog-databases--mysql--pgsql-or-sqlite-----required---)
  * [Configure custom directories, permissions and version of baculaweb](#configure-custom-directories--permissions-and-version-of-baculaweb)
  * [Configure baculaweb](#configure-baculaweb)
4. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
  * [Setup testing and development environment (MacOSX)](#setup-testing-and-development-environment--macosx-)
  * [Running acceptance Tests](#running-acceptance-tests)
7. [Release Notes/Contributors/Etc. **Optional**](#release-notes-contributors-etc---optional--)

## Overview

This module install and configures the baculaweb a web based reporting and monitoring tool for Bacula.

You can find the baculaweb documention here: https://www.bacula-web.org/ 

The module only install and configure the webapp itself. You still require a webserver (nginx or apache) with php.

## Requirements

* Puppet >= 4.10.0 < 7.0.0
* [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
* [puppet/archive](https://github.com/voxpupuli/puppet-archive)

### Optional Setup Requirements

Recommended modules for apache + php setup:
* [puppetlabs/apache](https://github.com/puppetlabs/puppetlabs-apache)
* [puppet/php](https://github.com/voxpupuli/puppet-php)

The needed requirements for the webserver and for php are documented here: 

http://docs.bacula-web.org/en/latest/02_install/requirements.html

### Beginning with baculaweb
All parameters for the baculaweb module are contained within the main baculaweb class, so for any function of the module, set the options you want. All configuration parameters can be assigned hiera. The default values are also lookuped up by hiera. See the common usages below for examples.

## Usage

### Install and enable baculaweb
```
include baculaweb
```

### Configure one or more bacula catalog databases (mysql, pgsql or sqlite) ***Required***
To get baculaweb up and running configure at least one bacula catalog database with the paramter catalog_db.

See the following example for the different catalog database types:

```
class { 'baculaweb':
  catalog_db => [
    {
      'label'    => 'EXAMPLE: MySQL backup catalog',
      'host'     => 'localhost',
      'login'    => 'bacula',
      'password' => 'verystrongpassword',
      'db_name'  => 'bacula',
      'db_type'  => 'mysql',
      'db_port'  => 3306,
    },
    {
      'label'    => 'EXAMPLE: PostgreSQL backup catalog',
      'host'     => 'localhost',
      'login'    => 'bacula',
      'password' => 'verystrongpassword',
      'db_name'  => 'bacula',
      'db_type'  => 'mysql',
      'db_port'  => 3306,
    },
    {
      'label'   => 'EXAMPLE: SQLite backup catalog',
      'db_name' => '/path/to/database',
      'db_type' => 'sqlite',
    },
  ]
}
```

Using Hiera:

```
baculaweb::catalog_db:
  - label: 'EXAMPLE: MySQL backup catalog'
    host: 'localhost'
    login: 'bacula'
    password: 'verystrongpassword'
    db_name: 'bacula'
    db_type: 'mysql'
    db_port: 3306
  - label: 'EXAMPLE: PostgreSQL backup catalog'
    host: 'localhost'
    login: 'bacula'
    password: 'verystrongpassword'
    db_name: 'bacula'
    db_type: 'pgsql'
    db_port: 5432
  - label: 'EXAMPLE: SQLite backup catalog'
    db_name: '/path/to/database'
    db_type: 'sqlite'
```

### Configure custom directories, permissions and version of baculaweb

```
class { 'baculaweb':
  version           => '8.3.3'
  root_dir          => '/var/www/html/bacula-web',
  extract_base_dir  => '/opt/bacula-web',
  user              => 'apache',
  group             => 'apache'
}
```

Using Hiera:

```
baculaweb:
  version: '8.3.3'
  root_dir: '/var/www/html/bacula-web'
  extract_base_dir: '/opt/bacula-web'
  user: 'apache'
  group: 'apache'
```

### Configure baculaweb

You find an overview of the baculaweb settings here: http://docs.bacula-web.org/en/latest/02_install/configure.html

See the following example to configure the settings:

```
class { 'baculaweb':
  language              => 'en_US',
  hide_empty_pools      => true,
  show_inactive_clients => true,
  datetime_format       => 'Y-m-d H:i:s',
  enable_users_auth     => false,
  debug                 => false,
  catalog_db            => [
    {
      'label'    => 'MySQL backup catalog',
      'host'     => 'localhost',
      'login'    => 'bacula',
      'password' => 'verystrongpassword',
      'db_name'  => 'bacula',
      'db_type'  => 'mysql',
      'db_port'  => 3306,
    },
  ]
}
```

Using Hiera:

```
baculaweb:
  language: 'en_US'
  hide_empty_pools: true
  show_inactive_clients: true
  datetime_format: 'Y-m-d H:i:s'
  enable_users_auth: false
  debug: false
  catalog_db:
    - label: 'MySQL backup catalog'
      host: 'localhost'
      login: 'bacula'
      password: 'verystrongpassword'
      db_name: 'bacula'
      db_type: 'mysql'
      db_port: 3306
```

## Reference

See [REFERENCE.md](REFERENCE.md)

## Limitations

For a list of supported operating systems, see [metadata.json](metadata.json)

## Development

This module uses [puppet_litmus](https://github.com/puppetlabs/puppet_litmus) for running acceptance tests.

### Setup testing and development environment (MacOSX)

Install required software with [brew](https://brew.sh/)
```
brew cask install docker
brew cask install puppetlabs/puppet/pdk
brew cask install puppet-bolt
brew install rbenv
rbenv init
echo 'eval "$(rbenv init -)"' >> $HOME/.zshrc
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
rbenv install 2.6.5
```

Then execute the following command in the root dir of the module:
```
rbenv local 2.6.5
gem install bundle
bundle install --path .bundle/gems/

```

To configure the CentOS docker container:
```
bundle exec rake 'litmus:provision_list[default]'
bolt command run 'yum -y install http php php php-gettext php-mysql php-pdo php-pgsql php-process' -n localhost:2222 -i inventory.yaml
bolt command run 'service httpd start' -n localhost:2222 -i inventory.yaml 

docker exec -it waffleimage_centos7_-2222 /bin/bash

vim /etc/httpd/conf.d/bacula-web.conf
<Directory /var/www/html/bacula-web>
  AllowOverride All
</Directory>

vim /etc/php.ini
date.timezone = Europe/Berlin

service httpd restart

```

Build ssh tunnel and access the baculaweb application:
```
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@localhost -p 2222 -L 27000:localhost:80 -Nf
http://localhost:27000/
```
http://localhost:27000/

### Running acceptance Tests

Update module code in container & run tests:
```
bolt command run 'puppet module uninstall andeman-baculaweb' -n localhost:2222 -i inventory.yaml 
bundle exec rake litmus:install_module
bundle exec rake litmus:acceptance:parallel
```

## Release Notes/Contributors/Etc. **Optional**

See [CHANGELOG.md](CHANGELOG.md)