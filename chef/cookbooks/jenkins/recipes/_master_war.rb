#
# Cookbook:: jenkins
# Recipe:: _master_war
#
# Author: AJ Christensen <aj@junglist.gen.nz>
# Author: Doug MacEachern <dougm@vmware.com>
# Author: Fletcher Nichol <fnichol@nichol.ca>
# Author: Seth Chisamore <schisamo@chef.io>
# Author: Seth Vargo <sethvargo@gmail.com>
#
# Copyright:: 2010-2016, VMware, Inc.
# Copyright:: 2012-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Create the Jenkins user
user node['jenkins']['master']['user'] do
  home node['jenkins']['master']['home']
  system node['jenkins']['master']['use_system_accounts']
end

# Create the Jenkins group
group node['jenkins']['master']['group'] do
  members node['jenkins']['master']['user']
  system node['jenkins']['master']['use_system_accounts']
end

# Create the home directory
directory node['jenkins']['master']['home'] do
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      node['jenkins']['master']['mode']
  recursive true
end

# Create the log directory
directory node['jenkins']['master']['log_directory'] do
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
  recursive true
end

package jenkins_font_packages

# Download the remote WAR file
remote_file File.join(node['jenkins']['master']['home'], 'jenkins.war') do
  source   node['jenkins']['master']['source']
  checksum node['jenkins']['master']['checksum'] if node['jenkins']['master']['checksum']
  owner    node['jenkins']['master']['user']
  group    node['jenkins']['master']['group']
  notifies :restart, 'service[jenkins]'
end

# disable runit services before starting new service
# TODO: remove in future version

%w(
  /etc/init.d/jenkins
  /etc/service/jenkins
).each do |f|
  file f do
    action :delete
    notifies :stop, 'service[jenkins]', :before
  end
end

# runit_service = if platform_family?('debian')
#                   'runit'
#                 else
#                   'runsvdir-start'
#                 end
# service runit_service do
#   action [:stop, :disable]
# end

#
# systemd ExecStart does not fully support shell-style quoting as
# might be expected by jvm_options etc.  But it does support a leading
# quote, trailing quote, and escaping in between, and we can ask
# /bin/sh to make sense of the rest.
#
systemd_unit 'jenkins.service' do
  content <<~EOU
    #
    # Generated by Chef for #{node['fqdn']}
    # Changes will be overwritten!
    #

    [Unit]
    Description=Jenkins master service (WAR)

    [Service]
    Type=simple
    User=#{node['jenkins']['master']['user']}
    Group=#{node['jenkins']['master']['group']}
    Environment="HOME=#{node['jenkins']['master']['home']}"
    Environment="JENKINS_HOME=#{node['jenkins']['master']['home']}"
    WorkingDirectory=#{node['jenkins']['master']['home']}
    #{ulimits_to_systemd(node['jenkins']['master']['ulimits'])}
    ExecStart=/bin/sh -c 'exec #{"#{node['jenkins']['java']} #{node['jenkins']['master']['jvm_options']} -jar jenkins.war --httpPort=#{node['jenkins']['master']['port']} --httpListenAddress=#{node['jenkins']['master']['listen_address']} #{node['jenkins']['master']['jenkins_args']}".gsub("'", "\\\\'")}'

    [Install]
    WantedBy=multi-user.target
  EOU
  action :create
end

service 'jenkins' do
  action [:enable, :start]
end
