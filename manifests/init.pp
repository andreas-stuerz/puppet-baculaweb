# == Class: baculaweb
#
# Installs a bacula-web - Open source web based reporting and monitoring tool for Bacula
#
class baculaweb (
  String $version,
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror,
  Stdlib::Compat::Absolute_path $extract_dir,
  Boolean $archive_symlink,
  Stdlib::Compat::Absolute_path $root_dir,
) {
  contain baculaweb::install
  contain baculaweb::config

  Class['::baculaweb::install']
  -> Class['::baculaweb::config']

}
