# frozen_string_literal: true
require 'puppet_litmus'
require 'singleton'
require 'tempfile'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.before :suite do
    LitmusHelper.instance.run_shell('puppet module install puppetlabs-apache')
    LitmusHelper.instance.run_shell('puppet module install puppet/php')
    #if os[:family] == 'debian' || os[:family] == 'ubuntu'
    #  # needed for the puppet fact
    #  apply_manifest("package { 'lsb-release': ensure => installed, }", expect_failures: false)
    #end
    ## needed for the grant tests, not installed on el7 docker images
    #apply_manifest("package { 'which': ensure => installed, }", expect_failures: false)
  end
end