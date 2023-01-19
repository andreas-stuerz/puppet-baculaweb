require 'spec_helper_acceptance'

if os[:family] == 'redhat'
  webserver_user = 'apache'
elsif os[:family] =~ %r{debian|ubuntu}
  webserver_user = 'www-data'
end

describe 'setup' do
  bacula_version = '8.3.3'
  bacula_root_dir = '/var/www/html/bacula-web'
  pp = <<-PUPPETCODE
    class { 'baculaweb':
      version  => '#{bacula_version}',
      root_dir => '#{bacula_root_dir}',
    }
  PUPPETCODE
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end
  it 'installed correct version' do
    run_shell("sudo -u #{webserver_user} sh -c 'cd #{bacula_root_dir} && php bwc help'") do |r|
      expect(r.stdout).to match(%r{Bacula-Web version #{bacula_version}})
    end
  end
  it 'requirements and permissions are OK' do
    run_shell("sudo -u #{webserver_user} sh -c 'cd #{bacula_root_dir} && php bwc check'") do |r|
      expect(r.stdout).to match(%r{PHP version.*Ok\S})
      expect(r.stdout).to match(%r{PHP timezone.*Ok\S})
      expect(r.stdout).to match(%r{Protected assets folder is writable.*Ok\S})
      expect(r.stdout).to match(%r{Smarty cache folder write permission.*Ok\S})
      expect(r.stdout).to match(%r{PHP Posix support.*Ok\S})
      expect(r.stdout).to match(%r{PHP Posix support.*Ok\S})
      expect(r.stdout).to match(%r{PHP PDO support.*Ok\S})
      expect(r.stdout).to match(%r{PHP SQLite support.*Ok\S})
      expect(r.stdout).to match(%r{driver\: mysql})
      expect(r.stdout).to match(%r{driver\: pgsql})
      expect(r.stdout).to match(%r{driver\: sqlite})
      expect(r.stdout).to match(%r{PHP Gettext support.*Ok\S})
      expect(r.stdout).to match(%r{PHP Session support.*Ok\S})
    end
  end
end
