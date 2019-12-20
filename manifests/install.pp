# @summary
#   Download the baculaweb source and install it in the root_dir
#
# @api private
#
class baculaweb::install {

  file { [
    $baculaweb::extract_base_dir,
    $baculaweb::extract_dir
  ]:
    ensure  => directory,
    recurse => true
  }

  archive { $baculaweb::archive_path:
    source        => $baculaweb::mirror,
    extract       => true,
    extract_path  => $baculaweb::extract_dir,
    extract_flags => '-x --no-same-owner -f',
    creates       => $baculaweb::extract_creates,
    cleanup       => true,
    require       => File[$baculaweb::extract_dir]
  }


  if $baculaweb::archive_symlink_to_root_dir {
    file { $baculaweb::root_dir:
      ensure  => link,
      target  => $baculaweb::extract_creates,
      owner   => $baculaweb::user,
      group   => $baculaweb::group,
      require => [
        Archive[$baculaweb::archive_path]
      ]
    }
  }

}
