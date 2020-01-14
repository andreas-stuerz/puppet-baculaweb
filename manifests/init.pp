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
  Stdlib::Compat::Absolute_path $config_path,
  Stdlib::Compat::Absolute_path $cache_path,
  Stdlib::Compat::Absolute_path $assets_protected_path,
  Boolean $show_inactive_clients,
  Boolean $hide_empty_pools,
  String $datetime_format,
  Boolean $enable_users_auth,
  Boolean $debug,
  Enum['en_US', 'be_BY', 'ca_ES', 'pl_PL', 'ru_RU', 'zh_CN', 'no_NO',
    'ja_JP', 'sv_SE', 'es_ES', 'de_DE', 'it_IT', 'fr_FR', 'pt_BR', 'nl_NL'] $language,
  Array[Struct[{
    label     => String,
    host      => Optional[String],
    login     => Optional[String],
    password  => Optional[String],
    db_name   => Optional[String],
    db_type   => Enum['mysql', 'pgsql', 'sqlite'],
    db_port   => Optional[Integer],
  }]] $catalog_db,

) {
  contain baculaweb::install
  contain baculaweb::config

  Class['::baculaweb::install']
  -> Class['::baculaweb::config']

}


