# OpenSSL Install Cookbook

[![License](https://img.shields.io/github/license/ualaska-it/openssl_install.svg)](https://github.com/ualaska-it/openssl_install)
[![GitHub Tag](https://img.shields.io/github/tag/ualaska-it/openssl_install.svg)](https://github.com/ualaska-it/openssl_install)
[![Build status](https://ci.appveyor.com/api/projects/status/tw56lorxstg0ua5h/branch/master?svg=true)](https://ci.appveyor.com/project/UAlaska/openssl-install/branch/master)

__Maintainer: OIT Systems Engineering__ (<ua-oit-se@alaska.edu>)

## Purpose

This cookbook provides a single resource that downloads, configures, compiles, and installs OpenSSL.

## Requirements

### Chef

This cookbook requires Chef 14+

### Platforms

Supported Platform Families:

* Debian
  * Ubuntu, Mint
* Red Hat Enterprise Linux
  * Amazon, CentOS, Oracle
* Suse

Platforms validated via Test Kitchen:

* Ubuntu
* Debian
* CentOS
* Oracle
* Fedora
* Amazon
* Suse

Notes:

* This cookbook should support any recent Linux variant.

### Dependencies

This cookbook does not constrain its dependencies because it is intended as a utility library.
It should ultimately be used within a wrapper cookbook.

## Resources

This cookbook provides one resource for creating an OpenSSL installation.

### openssl_installation

This resource provides a single action to create an OpenSSL installation.

__Actions__

One action is provided.

* `:create` - Post condition is that source and binary artifacts exist in specified directories.

__Attributes__

* `version` - Defaults to `nil`.
The version of OpenSSL to install.
If nil, will default to the latest version when this cookbook was updated.
The helper `default_openssl_version` is provided for fetching this value.
* `download_directory` - Defaults to `nil`.
The local path to the directory into which to download the source archive.
See note below about paths.
* `build_directory` - Defaults to `nil`.
The local path to the directory into which to decompress and build the source code.
See note below about paths.
* `install_directory` - Defaults to `nil`.
The local path to the directory into which to install the binary artifacts.
See note below about paths.
* `owner` - Defaults to `root`.
The owner of all artifacts.
* `group` - Defaults to `root`.
The group of all artifacts.
* `strict_security` - Defaults to `true`.
Determines if unsecure features of OpenSSL are disabled.
These include SSL2, SSL3 and RC4.
If true, a change to the source path (moving the source file) will cause the resource to converge and signal subscribers.
The source path is canonicalized before recording so relative, absolute, double dots, and multiple slashes do not matter.

__Note on paths__

If a path is set for download, build or install, then the client must assure the directory exists before the resource runs.
The resource runs as root and sets permissions on any created files, so is capable of placing a user-owned directory in a root-owned directory.

Fairly standard defaults are used for paths.
If download_directory or build_directory is nil (default), '/var/chef/cache' will be used.
If install directory is nil (default), "/opt/openssl/#{version}" will be created and used.

For build_directory, the path given is the _parent_ of the source root that is created when the archive is extracted.
For example, if build_directory is set to '/usr/local/openssl-src', then the source root will be "/usr/local/openssl-src/openssl-#{version}".

For install_directory, the path given is the root of the install.
For example, if install_directory is set to '/usr/local/openssl', then the path to the OpenSSL shared library will be '/usr/local/openssl/lib/libssl.so'.
The lib path must be added to linker and runtime configurations (typically use -L and rpath, respectively) for dependents to load the custom libraries.

## Recipes

This cookbook provides no recipes.

## Examples

Custom resources can be used as below.

```ruby
openssl_installation 'No Defaults' do
  version '1.1.0l'
  download_directory '/usr/local/openssl-dl'
  build_directory '/usr/local/openssl-bld'
  install_directory '/usr/local/openssl'
  owner 'some-dude'
  group 'some-dudes'
  strict_security false
end
```

## Development

See CONTRIBUTING.md and TESTING.md.
