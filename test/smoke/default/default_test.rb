# Inspec test for recipe elasticbeat::test_recipe

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# filebeat
describe package('filebeat') do
  it { should be_installed }
end

base_dir = '/etc/filebeat'
instance_dir = "#{base_dir}/foo"
modules_dir = "#{instance_dir}/modules.d"

describe file(modules_dir) do
  it { should exist }
  it { should be_directory }
end

describe file("#{instance_dir}/fields.yml") do
  it { should exist }
  it { should be_file }
end

describe file('/etc/systemd/system/filebeat@.service') do
  it { should exist }
  it { should be_file }
end

describe service('filebeat@foo') do
  it { should be_enabled }
  it { should be_running }
end

# journalbeat
describe package('journalbeat') do
  it { should be_installed }
end

base_dir = '/etc/journalbeat'
instance_dir = "#{base_dir}/bar"

describe file("#{instance_dir}/fields.yml") do
  it { should exist }
  it { should be_file }
end

describe file('/etc/systemd/system/journalbeat@.service') do
  it { should exist }
  it { should be_file }
end

describe service('journalbeat@bar') do
  it { should be_enabled }
  it { should be_running }
end
