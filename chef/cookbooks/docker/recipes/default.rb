#
# Cookbook:: docker
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

docker_installation_script 'default' do
    repo 'main'
    script_url 'http://get.docker.com'
    action :create
  end

docker_service 'default' do
    action [:create, :start]
  end