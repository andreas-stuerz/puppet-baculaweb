# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include baculaweb::config
class baculaweb::config {

  file { $baculaweb::cache_path:
    mode  => '0755',
    owner => $baculaweb::user,
  }

  file { $baculaweb::config_path:
    content => template('baculaweb/config.php.epp'),
    owner   => $baculaweb::user,
    group   => $baculaweb::group,
  }

}