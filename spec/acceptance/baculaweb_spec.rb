require 'spec_helper_acceptance'

pp_with_defaults = <<-PUPPETCODE
    class { 'baculaweb': }
PUPPETCODE

describe 'Execute Class' do
  context 'with default values' do
    it do
      idempotent_apply(pp_with_defaults)
    end
  end
end
