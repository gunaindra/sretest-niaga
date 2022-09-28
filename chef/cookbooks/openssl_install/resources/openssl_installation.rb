# frozen_string_literal: true

resource_name :openssl_installation
provides :openssl_installation

default_action :create

property :version, [String, nil], default: nil
property :download_directory, [String, nil], default: nil
property :build_directory, [String, nil], default: nil
property :install_directory, [String, nil], default: nil
property :owner, String, default: 'root'
property :group, String, default: 'root'
property :strict_security, [true, false], default: true

action :create do
  create_install(@new_resource)
end

action_class do
  include OpenSslInstall::Install
end
