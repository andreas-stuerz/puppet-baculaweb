# @summary
#   Download the baculaweb source and install it in the root_dir
#
# @api private
#
class baculaweb::install {
  file { [
      $baculaweb::extract_base_dir,
      $baculaweb::extract_dir,
      $baculaweb::data_dir,
    ]:
      ensure    => directory,
      recurse   => true,
      max_files => -1,
  }

  file { [
      $baculaweb::data_dir_assets_protected_path,
    ]:
      ensure    => directory,
      owner     => $baculaweb::user,
      mode      => '0755',
      max_files => -1,
  }

  archive { $baculaweb::archive_path:
    source        => $baculaweb::mirror,
    extract       => true,
    extract_path  => $baculaweb::extract_dir,
    extract_flags => '-x --no-same-owner -f',
    creates       => $baculaweb::extract_creates,
    cleanup       => true,
    require       => File[$baculaweb::extract_dir],
  }

  if $baculaweb::archive_symlink_to_root_dir {
    file { $baculaweb::root_dir:
      ensure  => link,
      target  => $baculaweb::extract_creates,
      owner   => $baculaweb::user,
      group   => $baculaweb::group,
      require => Archive[$baculaweb::archive_path],
    }
  }

  if $baculaweb::data_dir_symlink {
    file { "${baculaweb::data_dir_assets_protected_path}/.htaccess":
      ensure => file,
      source => 'puppet:///modules/baculaweb/htaccess_protected.epp',
      mode   => '0644',
    }

    # create default appliaction database if it not exists
    # Login with admin:password
    file { "${baculaweb::data_dir_assets_protected_path}/application.db":
      ensure  => file,
      replace => 'no',
      source  => 'puppet:///modules/baculaweb/application.db',
      owner   => $baculaweb::user,
      group   => $baculaweb::group,
      mode    => '0644',
      require => File[$baculaweb::data_dir_assets_protected_path],
    }

    file { "symlink_{${baculaweb::assets_protected_path}}":
      ensure  => link,
      force   => true,
      path    => $baculaweb::assets_protected_path,
      target  => $baculaweb::data_dir_assets_protected_path,
      owner   => $baculaweb::user,
      group   => $baculaweb::group,
      mode    => '0755',
      require => [
        File[$baculaweb::data_dir_assets_protected_path],
        File[$baculaweb::root_dir],
        File["${baculaweb::data_dir_assets_protected_path}/.htaccess"],
      ],
    }
  }
}
