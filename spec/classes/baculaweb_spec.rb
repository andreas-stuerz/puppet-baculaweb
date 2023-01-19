require 'spec_helper'

describe 'baculaweb' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'Compiles the catalog' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'contain the classes' do
        it { is_expected.to contain_class('baculaweb::install') }
        it { is_expected.to contain_class('baculaweb::config') }
        it { is_expected.to contain_class('baculaweb::install').that_comes_before('Class[baculaweb::config]') }
      end

      describe 'contain the resources' do
        it {
          is_expected.to contain_archive('/opt/bacula-web/bacula-web-8.3.3.tgz').with(
            'source' => 'https://github.com/bacula-web/bacula-web/releases/download/v8.3.3/bacula-web-8.3.3.tgz',
          )
          is_expected.to contain_file('/opt/bacula-web/v8.3.3').with(
            'ensure'  => 'directory',
          )
          is_expected.to contain_file('/opt/bacula-web').with(
            'ensure'  => 'directory',
          )
          is_expected.to contain_file('/var/www/html/bacula-web/application/assets/protected').with(
            'mode' => '0755',
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
