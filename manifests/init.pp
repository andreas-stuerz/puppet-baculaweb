# == Class: baculaweb
#
# Installs a bacula-web - Open source web based reporting and monitoring tool for Bacula
# see: https://www.bacula-web.org/
#
class baculaweb (
  String $version,
  String $archive_name,
  String $user,
  String $group,
  Stdlib::Compat::Absolute_path $archive_path,
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror_base_url,
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror,
  Stdlib::Compat::Absolute_path $extract_base_dir,
  Stdlib::Compat::Absolute_path $extract_dir,
  Stdlib::Compat::Absolute_path $extract_creates,
  Boolean $archive_symlink_to_root_dir,
  Stdlib::Compat::Absolute_path $root_dir,
) {
  contain baculaweb::install
  contain baculaweb::config

  Class['::baculaweb::install']
  -> Class['::baculaweb::config']

}
