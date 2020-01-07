require 'spec_helper'

describe 'baculaweb' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('baculaweb::install') }
      it { is_expected.to contain_class('baculaweb::config') }
      it { is_expected.to contain_class('baculaweb::install').that_comes_before('Class[baculaweb::config]') }
    end
  end
end
