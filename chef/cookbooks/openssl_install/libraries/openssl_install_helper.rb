# frozen_string_literal: true

require 'source_install'

# This module implements helpers that are used for resources
module OpenSslInstall
  # This module exposes helpers to the client
  module Public
    def default_openssl_version
      return '1.1.1d'
    end

    def default_openssl_directory
      # Must match source_install
      return "/opt/openssl/#{default_openssl_version}"
    end
  end

  # This module implements helpers that are used for resources
  module Install
    include Source::Install

    # Hooks for install

    def base_name(_new_resource)
      return 'openssl'
    end

    def default_version(_new_resource)
      return default_openssl_version
    end

    def archive_file_name(new_resource)
      return "#{base_name(new_resource)}-#{new_resource.version}.tar.gz"
    end

    def download_base_url(_new_resource)
      return 'https://www.openssl.org/source'
    end

    def archive_root_directory(new_resource)
      return "#{base_name(new_resource)}-#{new_resource.version}"
    end

    def extract_creates_file(_new_resource)
      return 'README'
    end

    def configuration_command(new_resource)
      code = './config shared'
      code += " -Wl,-rpath=#{File.join(new_resource.install_directory, 'lib')}"
      code += ' no-ssl2 no-ssl3 no-weak-ssl-ciphers' if new_resource.strict_security
      code += " --prefix=#{new_resource.install_directory}"
      code += " --openssldir=#{new_resource.install_directory}"
      return code
    end

    def install_creates_file(_new_resource)
      return 'bin/openssl'
    end

    def install_command(_new_resource)
      return 'make install'
    end

    # For optional hooks and common install code see source_install cookbook
  end
end

Chef::Provider.include(OpenSslInstall::Public)
Chef::Recipe.include(OpenSslInstall::Public)
Chef::Resource.include(OpenSslInstall::Public)
