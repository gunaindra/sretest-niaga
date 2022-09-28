# frozen_string_literal: true

node = json('/opt/chef/run_record/last_chef_run_node.json')['automatic']

BASE_NAME = 'openssl'
CURR_VER = '1.1.1d'
PREV_VER = '1.1.0l'

def archive_file(version)
  return "#{BASE_NAME}-#{version}.tar.gz"
end

def source_dir(version)
  return "#{BASE_NAME}-#{version}"
end

describe package 'gcc' do
  it { should be_installed }
end

describe package 'g++' do
  it { should be_installed } if node['platform_family'] == 'debian'
end

describe package 'gcc-c++' do
  it { should be_installed } unless node['platform_family'] == 'debian'
end

describe package 'make' do
  it { should be_installed }
end

describe file "/usr/local/#{BASE_NAME}-dl" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}-bld" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe user 'bud' do
  it { should exist }
  its('group') { should eq 'bud' }
  its('groups') { should eq ['bud'] }
  its('home') { should eq '/home/bud' }
  its('shell') { should eq '/bin/bash' }
end

# Begin white-box testing of resources

describe file '/var/chef' do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file '/var/chef/cache' do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/var/chef/cache/#{archive_file(CURR_VER)}" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}-dl/#{archive_file(PREV_VER)}" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

describe file "/var/chef/cache/#{source_dir(CURR_VER)}" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o775 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}-bld/#{source_dir(PREV_VER)}" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o775 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

describe file "/var/chef/cache/#{BASE_NAME}-#{CURR_VER}-dl-checksum" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/var/chef/cache/#{BASE_NAME}-#{PREV_VER}-dl-checksum" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/var/chef/cache/#{BASE_NAME}-#{CURR_VER}-src-checksum" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/var/chef/cache/#{BASE_NAME}-#{PREV_VER}-src-checksum" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/var/chef/cache/#{source_dir(CURR_VER)}/README" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o664 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}-bld/#{source_dir(PREV_VER)}/README" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o664 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

describe file "/opt/#{BASE_NAME}" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/opt/#{BASE_NAME}/#{CURR_VER}" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}" do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/var/chef/cache/#{source_dir(CURR_VER)}/Makefile" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}-bld/#{source_dir(PREV_VER)}/Makefile" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

# TODO: Tests for config entries

describe file "/opt/#{BASE_NAME}/#{CURR_VER}/include/#{BASE_NAME}/#{BASE_NAME}conf.h" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}/include/#{BASE_NAME}/#{BASE_NAME}conf.h" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o644 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

describe file "/opt/#{BASE_NAME}/#{CURR_VER}/lib/libssl.so" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}/lib/libssl.so" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

describe file "/opt/#{BASE_NAME}/#{CURR_VER}/bin/#{BASE_NAME}" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file "/usr/local/#{BASE_NAME}/bin/#{BASE_NAME}" do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by 'bud' }
  it { should be_grouped_into 'bud' }
end

describe bash "/opt/#{BASE_NAME}/#{CURR_VER}/bin/#{BASE_NAME} version" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match(/1\.1\.1d/) }
end

describe bash "/usr/local/#{BASE_NAME}/bin/#{BASE_NAME} version" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match(/1\.1\.0l/) }
end

describe bash "/opt/#{BASE_NAME}/#{CURR_VER}/bin/#{BASE_NAME} ciphers -v" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match(/TLSv1\.2/) }
  its(:stdout) { should_not match(/TLSv1\.1/) }
  its(:stdout) { should match(/TLSv1\s/) }
  its(:stdout) { should match(/SSLv3/) } # These are used by TLSv1
  its(:stdout) { should_not match(/SSLv2/) }
  its(:stdout) { should_not match(/SSLv1/) }
end

describe bash "/usr/local/#{BASE_NAME}/bin/#{BASE_NAME} ciphers -v" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match(/TLSv1\.2/) }
  its(:stdout) { should_not match(/TLSv1\.1/) }
  its(:stdout) { should match(/TLSv1\s/) }
  its(:stdout) { should match(/SSLv3/) }
  its(:stdout) { should_not match(/SSLv2/) }
  its(:stdout) { should_not match(/SSLv1/) }
end
