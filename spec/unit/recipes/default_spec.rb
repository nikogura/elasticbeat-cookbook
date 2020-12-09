#
# Cookbook:: elasticbeat
# Spec:: default
#
# Copyright:: 2020, Nik Ogura, All Rights Reserved.

require 'spec_helper'

describe 'elasticbeat::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        # add node attributes here such as:
        # node.automatic['foo']['ips']['private_ip'] = '192.168.0.1'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
