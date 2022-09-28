# frozen_string_literal: true

include_recipe 'openssl_install::default'

openssl_installation 'All Defaults'

[
  '/usr/local/openssl-dl',
  '/usr/local/openssl-bld',
  '/usr/local/openssl'
].each do |dir|
  directory dir do
    user 'root'
    group 'root'
    mode 0o755
  end
end

user 'bud' do
  shell '/bin/bash'
end

openssl_installation 'No Defaults' do
  version '1.1.0l'
  download_directory '/usr/local/openssl-dl'
  build_directory '/usr/local/openssl-bld'
  install_directory '/usr/local/openssl'
  owner 'bud'
  group 'bud'
  strict_security false
end
