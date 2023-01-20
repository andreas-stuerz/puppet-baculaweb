# baculaweb

#### Table of Contents

- [baculaweb](#baculaweb)
  - [Table of Contents](#table-of-contents)
  * [Overview](#overview)
  * [Requirements](#requirements)
    + [Optional Setup Requirements](#optional-setup-requirements)
    + [Beginning with baculaweb](#beginning-with-baculaweb)
  * [Usage](#usage)
    + [Install and enable baculaweb](#install-and-enable-baculaweb)
    + [Default User and Password for fresh installs](#default-user-and-password-for-fresh-installs)
    + [Configure bacula catalog databases](#configure-bacula-catalog-databases)
    + [Configure custom installation options](#configure-custom-installation-options)
    + [Configure baculaweb](#configure-baculaweb)
  * [Reference](#reference)
  * [Limitations](#limitations)
  * [Development](#development)
    + [Running acceptance tests](#running-acceptance-tests)
    + [Running unit tests](#running-unit-tests)
  * [Contributing](#contributing)
  * [Release Notes](#release-notes)


## Overview

This module install and configures the baculaweb a web based reporting and monitoring tool for Bacula.

You can find the baculaweb documention here: https://www.bacula-web.org/

The module only install and configure the webapp itself. You still require a webserver (nginx or apache) with php.

## Requirements

* Puppet >= 6.0.0
* Bacula-Web 8.6.0 or later (due to breaking changes in this release)
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

### Default User and Password for fresh installs
After installation the default user is **admin** and the default password is **password**. You should change this after installation.

See: https://docs.bacula-web.org/en/latest/02_install/finalize.html#reset-user-password


The default application.db is only deployed once. Data is persisted between upgrades in `baculaweb::data_dir`.


### Configure bacula catalog databases
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

### Configure custom installation options

Configure custom directories, ownerships and version:

```
class { 'baculaweb':
  version           => '8.6.3'
  root_dir          => '/var/www/html/bacula-web',
  extract_base_dir  => '/opt/bacula-web',
  user              => 'apache',
  group             => 'apache'
}
```

Using Hiera:

```
baculaweb:
  version: '8.6.3'
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

### Running acceptance tests
Create test environment:
```
./scripts/create_test_env
```

Run the acceptance tests:
```
./scripts/acceptance_tests
```

(Optional) Access the baculaweb application (user/pw: admin/password):

http://127.0.0.1:8091/bacula-web


Remove the test environment:
```
./scripts/remove_test_env
```

### Running unit tests
```
./scripts/unit_tests
```

## Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

All contributions must pass all existing tests, new features should provide additional unit/acceptance tests.

## Release Notes

See [CHANGELOG.md](CHANGELOG.md)
# baculaweb

#### Table of Contents

- [baculaweb](#baculaweb)
  - [Table of Contents](#table-of-contents)
  * [Overview](#overview)
  * [Requirements](#requirements)
    + [Optional Setup Requirements](#optional-setup-requirements)
    + [Beginning with baculaweb](#beginning-with-baculaweb)
  * [Usage](#usage)
    + [Install and enable baculaweb](#install-and-enable-baculaweb)
    + [Default User and Password for fresh installs](#default-user-and-password-for-fresh-installs)
    + [Configure bacula catalog databases](#configure-bacula-catalog-databases)
    + [Configure custom installation options](#configure-custom-installation-options)
    + [Configure baculaweb](#configure-baculaweb)
  * [Reference](#reference)
  * [Limitations](#limitations)
  * [Development](#development)
    + [Running acceptance tests](#running-acceptance-tests)
    + [Running unit tests](#running-unit-tests)
  * [Contributing](#contributing)
  * [Release Notes](#release-notes)


## Overview

This module install and configures the baculaweb a web based reporting and monitoring tool for Bacula.

You can find the baculaweb documention here: https://www.bacula-web.org/

The module only install and configure the webapp itself. You still require a webserver (nginx or apache) with php.

## Requirements

* Puppet >= 6.0.0
* Bacula-Web 8.6.0 or later (due to breaking changes in this release)
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

### Default User and Password for fresh installs
After installation the default user is **admin** and the default password is **password**. You should change this after installation.

See: https://docs.bacula-web.org/en/latest/02_install/finalize.html#reset-user-password


The default application.db is only deployed once. Data is persisted between upgrades in `baculaweb::data_dir`.


### Configure bacula catalog databases
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

### Configure custom installation options

Configure custom directories, ownerships and version:

```
class { 'baculaweb':
  version           => '8.6.3'
  root_dir          => '/var/www/html/bacula-web',
  extract_base_dir  => '/opt/bacula-web',
  user              => 'apache',
  group             => 'apache'
}
```

Using Hiera:

```
baculaweb:
  version: '8.6.3'
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

### Running acceptance tests
Create test environment:
```
./scripts/create_test_env
```

Run the acceptance tests:
```
./scripts/acceptance_tests
```

(Optional) Access the baculaweb application (user/pw: admin/password):

http://127.0.0.1:8091/bacula-web


Remove the test environment:
```
./scripts/remove_test_env
```

### Running unit tests
```
./scripts/unit_tests
```
## Release module to Puppet Forge

### Prepare
First prepare the release with:

```
./scripts/release_prep
```

This will set the version in `metadata.json`, create `REFERENCE.md` and  `CHANGELOG.md`.

### Commit and push
Then commit the changes and push them to the repository.

### configure github actions secrets
https://github.com/andeman/puppet-opnsense/settings/secrets/actions

Ensure that the following secrets are set in the github repository:
- FORGE_API_KEY (your puppet forge api key)


### Run github actions release workflow
Then run github actions pipeline "Publish module to puppet forge" from main branch to release the module to the forge:

https://github.com/andeman/puppet-baculaweb/actions/workflows/release.yaml







## Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

All contributions must pass all existing tests, new features should provide additional unit/acceptance tests.

## Release Notes

See [CHANGELOG.md](CHANGELOG.md)
