# @summary
#   Configure the bacula-web application and set proper permissions
#
# @api private
#
class baculaweb::config {
  file { [
      $baculaweb::cache_path,
    ]:
      mode  => '0755',
      owner => $baculaweb::user,
  }

  file { $baculaweb::config_path:
    content => epp('baculaweb/config.php.epp'),
    owner   => $baculaweb::user,
    group   => $baculaweb::group,
  }
}
