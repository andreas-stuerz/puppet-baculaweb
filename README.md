# baculaweb

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
    * [What baculaweb affects](#what-baculaweb-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with baculaweb](#beginning-with-baculaweb)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module install and configures the baculaweb a web based reporting and monitoring tool for Bacula.

You can find the baculaweb documention here: https://www.bacula-web.org/ 

The module only install and configure the webapp itself. You still require a webserver (nginx or apache) with php.

## Requirements

* Puppet >= 4.10.0 < 7.0.0
* [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
* [puppet/archive](https://github.com/voxpupuli/puppet-archive)

### Setup Requirements **OPTIONAL**

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

###Configure one or more bacula catalog databases (mysql, pgsql or sqlite) ***Required***
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

###Configure custom directories, permissions and version of baculaweb

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

###Configure baculaweb

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

This section is deprecated. Instead, add reference information to your code as Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your module. For details on how to add code comments and generate documentation with Strings, see the Puppet Strings [documentation](https://puppet.com/docs/puppet/latest/puppet_strings.html) and [style guide](https://puppet.com/docs/puppet/latest/puppet_strings_style.html)

If you aren't ready to use Strings yet, manually create a 
 in the root of your module directory and list out each of your module's classes, defined types, facts, functions, Puppet tasks, task plans, and resource types and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

In the Limitations section, list any incompatibilities, known issues, or other warnings.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.

