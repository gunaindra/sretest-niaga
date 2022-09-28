# Source Install Cookbook

[![License](https://img.shields.io/github/license/ualaska-it/source_install.svg)](https://github.com/ualaska-it/source_install)
[![GitHub Tag](https://img.shields.io/github/tag/ualaska-it/source_install.svg)](https://github.com/ualaska-it/source_install)
[![Build status](https://ci.appveyor.com/api/projects/status/u8rh876pwwhwl1je/branch/master?svg=true)](https://ci.appveyor.com/project/UAlaska/source-install/branch/master)

__Maintainer: OIT Systems Engineering__ (<ua-oit-se@alaska.edu>)

## Purpose

This cookbook installs a gem in Chef that provides logic for downloading, configuring, compiling, and installing packages from source.
Used by first-party cookbooks [openssl_install](https://github.com/UAlaska-IT/openssl_install), [sqlite_install](https://github.com/UAlaska-IT/sqlite_install), and [python_install](https://github.com/UAlaska-IT/python_install).

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

This cookbook provides no resources but can be used to create install resources by extending SourceInstall::Install.

## Recipes

This cookbook provides no recipes.

## Examples

See example usage in [openssl_install](), [sqlite_install](), and [python_install]().

## Development

See CONTRIBUTING.md and TESTING.md.
