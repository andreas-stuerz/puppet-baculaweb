require 'spec_helper'

describe 'baculaweb' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'Compiles the catalog' do
        it {
          File.write(
            'catalog.json',
            PSON.pretty_generate(catalogue),
          )
          is_expected.to compile.with_all_deps
        }
      end

      describe 'contain the classes' do
        it { is_expected.to contain_class('baculaweb::install') }
        it { is_expected.to contain_class('baculaweb::config') }
        it { is_expected.to contain_class('baculaweb::install').that_comes_before('Class[baculaweb::config]') }
      end

      describe 'contain the resources' do
        it {
          is_expected.to contain_archive('/opt/bacula-web/bacula-web-8.6.3.tgz').with(
            'source' => 'https://github.com/bacula-web/bacula-web/releases/download/v8.6.3/bacula-web-8.6.3.tgz',
          )
          is_expected.to contain_file('/opt/bacula-web/v8.6.3').with(
            'ensure'  => 'directory',
          )
          is_expected.to contain_file('/opt/bacula-web').with(
            'ensure'  => 'directory',
          )
          is_expected.to contain_file('/opt/bacula-web/data').with(
            "ensure": 'directory',
            "recurse": true,
            "max_files": -1,
          )
          is_expected.to contain_file('/opt/bacula-web/data/protected').with(
            "ensure": 'directory',
            "owner": 'apache',
            "mode": '0755',
            "max_files": -1,
          )
          is_expected.to contain_file('/opt/bacula-web/data/protected/application.db').with(
            "ensure": 'file',
            "replace": 'no',
            "source": 'puppet:///modules/baculaweb/application.db',
            "owner": 'apache',
            "group": 'apache',
            "mode": '0644',
            "require": 'File[/opt/bacula-web/data/protected]',
          )
          is_expected.to contain_file('/opt/bacula-web/data/protected/.htaccess').with(
            "ensure": 'file',
            "source": 'puppet:///modules/baculaweb/htaccess_protected.epp',
            "mode": '0644',
          )
          is_expected.to contain_file('symlink_{/var/www/html/bacula-web/application/assets/protected}').with(
            "path": '/var/www/html/bacula-web/application/assets/protected',
            "ensure": 'link',
            "force": true,
            "target": '/opt/bacula-web/data/protected',
            "owner": 'apache',
            "group": 'apache',
            "mode": '0755',
            "require": [
              'File[/opt/bacula-web/data/protected]',
              'File[/var/www/html/bacula-web]',
              'File[/opt/bacula-web/data/protected/.htaccess]',
            ],
          )
          is_expected.to contain_file('/var/www/html/bacula-web/application/views/cache').with(
            'mode' => '0755',
          )
          is_expected.to contain_file('/var/www/html/bacula-web/application/config/config.php')
          is_expected.to contain_file('/var/www/html/bacula-web').with(
            'ensure' => 'link',
          )
        }
      end
    end
  end
end
