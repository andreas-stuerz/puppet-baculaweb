require 'spec_helper_acceptance'

def verify_version(target_version, root_dir)
  webserver_user = get_webserver_user
  run_shell("sudo -u #{webserver_user} sh -c 'cd #{root_dir} && php bwc help'") do |r|
    expect(r.stdout).to match(%r{Bacula-Web version #{target_version}})
  end
end

def verify_installation(version, root_dir)
  webserver_user = get_webserver_user
  run_shell("sudo -u #{webserver_user} sh -c 'cd #{root_dir} && php bwc check'") do |r|
    expect(r.stdout).to match(%r{PHP version.*Ok\S})
    expect(r.stdout).to match(%r{PHP timezone.*Ok\S})
    expect(r.stdout).to match(%r{Protected assets folder is writable.*Ok\S})
    expect(r.stdout).to match(%r{Smarty cache folder write permission.*Ok\S})

    if Gem::Version.new(version) >= Gem::Version.new('8.6.3')
      expect(r.stdout).to match(%r{mysql.*installed})
      expect(r.stdout).to match(%r{pgsql.*installed})
      expect(r.stdout).to match(%r{sqlite.*installed})
    else
      expect(r.stdout).to match(%r{driver:.*mysql})
      expect(r.stdout).to match(%r{driver:.*pgsql})
      expect(r.stdout).to match(%r{driver:.*sqlite})
    end

    expect(r.stdout).to match(%r{SQLite support.*Ok\S})
    expect(r.stdout).to match(%r{Gettext support.*Ok\S})
    expect(r.stdout).to match(%r{Session support.*Ok\S})
    expect(r.stdout).to match(%r{PHP PDO support.*Ok\S})
    expect(r.stdout).to match(%r{PHP Posix support.*Ok\S})
  end
end

def get_webserver_user
  if os[:family] == 'redhat'
    'apache'
  elsif %r{debian|ubuntu}.match?(os[:family])
    'www-data'
  end
end

describe 'baculaweb' do
  describe 'install version 8.6.2' do
    bacula_version = '8.6.2'
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
      verify_version(bacula_version, bacula_root_dir)
    end
    it 'requirements and permissions are OK' do
      verify_installation(bacula_version, bacula_root_dir)
    end
  end

  describe 'update to version 8.6.3' do
    bacula_version = '8.6.3'
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
      verify_version(bacula_version, bacula_root_dir)
    end
    it 'requirements and permissions are OK' do
      verify_installation(bacula_version, bacula_root_dir)
    end
  end
end
