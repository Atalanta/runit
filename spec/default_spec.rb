require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|

  config.platform = 'centos'
  config.version = '6.4'

  describe 'runit::default' do

    let(:chef_run) { ChefSpec::Runner.new }

    it 'includes the build-essential recipe unless set to use the Yum package' do
      chef_run.node.set["runit"]["use_package_from_yum"] = false
      stub_command("rpm -qa | grep -q '^runit'").and_return(true)
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('build-essential')
      chef_run.node.set["runit"]["use_package_from_yum"] = true
      chef_run.converge(described_recipe)
      expect(chef_run).to install_package('runit')
    end
  end

end
