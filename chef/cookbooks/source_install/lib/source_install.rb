# frozen_string_literal: true

# This module implements helpers that are used for resources
module Source
  # This module implements helpers that are used for resources
  module Install
    VERSION = '1.1.1'

    # Hooks for install

    def base_name(_new_resource)
      raise NotImplementedError('Client must define base application name e.g. "Python". \
This is frequently used to build e.g. archive file name and will be used to define default directories.')
    end

    def default_version(_new_resource)
      raise NotImplementedError('Client must provide a default version string e.g. "1.1.4".')
    end

    def archive_file_name(_new_resource)
      # noinspection RubyExpressionInStringInspection
      raise NotImplementedError('Client must indicate the filename of the what the archive file \
that will be downloaded, e.g. "#{base_name(new_resource)}-#{new_resource.version}.tar.gz"')
    end

    def download_base_url(_new_resource)
      raise NotImplementedError('Client must indicate the URL at which the archive file is located, \
e.g. "https://www.oss-project.org/source"')
    end

    def archive_root_directory(_new_resource)
      # noinspection RubyExpressionInStringInspection
      raise NotImplementedError('Client must indicate the directory created by extraction, \
e.g. "#{base_name(new_resource)}-#{new_resource.version}". This will be used as the build directory.')
    end

    def extract_creates_file(_new_resource)
      raise NotImplementedError('Client must indicate a relative path to a file that is created by extraction, \
e.g. "README.md"')
    end

    def configuration_command(_new_resource)
      raise NotImplementedError('Client must define the configuration command to be run before build, \
e.g. "./config shared --prefix..."')
    end

    def install_creates_file(_new_resource)
      raise NotImplementedError('Client must indicate a relative path to a file that is created by installation, \
e.g. "bin/my_app"')
    end

    # Optional hooks for install

    def build_command(_new_resource)
      return 'make'
    end

    def install_command(_new_resource)
      # This is probably the most common command, another option is 'make altinstall'
      return 'make install'
    end

    def post_install_logic(_new_resource)
      # Client may define logic to run after installation, for example for creating symlinks
    end

    def config_creates_file(_new_resource)
      # A relative path to a file created by configuration
      # If the client defines a config_creates_file, then the content of that file will be used to signal rebuild
      # Otherwise, a checksum is taken of the entire build directory
      # A file is less robust for signaling rebuild when config changes, but cleaner for nasty in-source builds
      return nil
    end

    # Common install code; the hooks are intended to save clients the effort of implementing anything below

    def ensure_version(new_resource)
      return if new_resource.version

      new_resource.version = default_version(new_resource)
    end

    def download_url(new_resource)
      url = download_base_url(new_resource)
      url += '/' unless url.match?(%r{/$})
      url += archive_file_name(new_resource)
      return url
    end

    def create_default_directories
      directory '/var/chef' do
        mode 0o755
        owner 'root'
        group 'root'
      end
      directory '/var/chef/cache' do
        mode 0o755
        owner 'root'
        group 'root'
      end
    end

    def path_to_download_directory(new_resource)
      return new_resource.download_directory if new_resource.download_directory

      create_default_directories
      return '/var/chef/cache'
    end

    def path_to_download_file(new_resource)
      directory = path_to_download_directory(new_resource)
      file = File.join(directory, archive_file_name(new_resource))
      return file
    end

    def download_archive(new_resource)
      download_file = path_to_download_file(new_resource)
      url = download_url(new_resource)
      remote_file download_file do
        source url
        owner new_resource.owner
        group new_resource.group
      end
      return download_file
    end

    def path_to_build_directory(new_resource)
      base = archive_root_directory(new_resource)
      return File.join(new_resource.build_directory, base) if new_resource.build_directory

      create_default_directories
      return File.join('/var/chef/cache', base)
    end

    def clear_source_directory(build_directory, new_resource)
      dir = build_directory
      bash 'Clear Archive' do
        code "rm -rf #{dir}\nmkdir #{dir}\nchown #{new_resource.owner}:#{new_resource.group} #{dir}"
        # Run as root so we blow it away if the owner changes
        action :nothing
        subscribes :run, 'checksum_file[Download Checksum]', :immediate
      end
    end

    def manage_source_directory(download_file, build_directory, new_resource)
      checksum_file 'Download Checksum' do
        source_path download_file
        target_path "/var/chef/cache/#{base_name(new_resource).downcase}-#{new_resource.version}-dl-checksum"
        include_metadata false
      end
      clear_source_directory(build_directory, new_resource)
    end

    def extract_command(filename)
      return 'unzip -q' if filename.match?(/\.zip/)

      return 'tar xzf' if filename.match?(/\.(:?tar\.gz|tgz)/)

      raise "Archive not supported: #{filename}"
    end

    def code_for_extraction(download_file, build_directory, new_resource)
      code = <<~CODE
        #{extract_command(download_file)} #{download_file}
        chown -R #{new_resource.owner}:#{new_resource.group} #{build_directory}
      CODE
      return code
    end

    def extract_download(download_file, build_directory, new_resource)
      # Built-in archive_file requires Chef 15 and poise_archive is failing to exhibit idempotence on zip files
      parent = File.dirname(build_directory)
      code = code_for_extraction(download_file, build_directory, new_resource)
      bash 'Extract Archive' do
        code code
        cwd parent
        # Run as root in case it is installing in directory without write access
        creates File.join(build_directory, extract_creates_file(new_resource))
      end
    end

    def extract_archive(build_directory, new_resource)
      download_file = download_archive(new_resource)
      manage_source_directory(download_file, build_directory, new_resource)
      extract_download(download_file, build_directory, new_resource)
    end

    def default_install_directory(new_resource)
      return "/opt/#{base_name(new_resource).downcase}/#{new_resource.version}"
    end

    def create_opt_directories(new_resource)
      directory "/opt/#{base_name(new_resource).downcase}" do
        mode 0o755
        owner 'root'
        group 'root'
      end
      directory default_install_directory(new_resource) do
        mode 0o755
        owner 'root'
        group 'root'
      end
    end

    def ensure_install_directory(new_resource)
      return if new_resource.install_directory

      create_opt_directories(new_resource)
      new_resource.install_directory = default_install_directory(new_resource)
    end

    def save_config(code, new_resource)
      file 'Config File' do
        path "/var/chef/cache/#{base_name(new_resource).downcase}-#{new_resource.version}-config"
        content code
        mode 0o644
        owner 'root'
        group 'root'
      end
    end

    def manage_make_file(build_directory, code, new_resource)
      save_config(code, new_resource)
      makefile = File.join(build_directory, 'Makefile')
      file makefile do
        action :nothing
        subscribes :delete, 'file[Config File]', :immediate
      end
      return makefile
    end

    def configure_build(build_directory, new_resource)
      code = configuration_command(new_resource)
      makefile = manage_make_file(build_directory, code, new_resource)
      bash 'Configure Build' do
        code code
        cwd build_directory
        user new_resource.owner
        group new_resource.group
        creates makefile
      end
    end

    def check_build_directory(build_directory, new_resource)
      creates_file = config_creates_file(new_resource)
      checksum_file 'Source Checksum' do
        source_path File.join(build_directory, creates_file) if creates_file
        source_path build_directory unless creates_file
        target_path "/var/chef/cache/#{base_name(new_resource).downcase}-#{new_resource.version}-src-checksum"
        include_metadata false
      end
    end

    def manage_bin_file(bin_file)
      file bin_file do
        action :nothing
        manage_symlink_source false
        subscribes :delete, 'checksum_file[Source Checksum]', :immediate
      end
    end

    def execute_build(build_directory, bin_file, new_resource)
      bash 'Compile' do
        code build_command(new_resource)
        cwd build_directory
        user new_resource.owner
        group new_resource.group
        creates bin_file
      end
    end

    def execute_install(build_directory, bin_file, new_resource)
      bash 'Install' do
        code install_command(new_resource)
        cwd build_directory
        # Run as root in case it is installing in directory without write access
        creates bin_file
      end
    end

    def recurse_command(path)
      return ' -R' if File.directory?(path)

      return ''
    end

    def command_for_file(filename, new_resource)
      path = File.join(new_resource.install_directory, filename)
      recurse = recurse_command(path)
      return "\nchown#{recurse} #{new_resource.owner}:#{new_resource.group} #{path}"
    end

    def iterate_install_directory(new_resource)
      command = ''
      Dir.foreach(new_resource.install_directory) do |filename|
        next if ['.', '..'].include?(filename)

        command += command_for_file(filename, new_resource)
      end
      return command
    end

    def build_permission_command(new_resource)
      ruby_block 'Build Children' do
        block do
          files = iterate_install_directory(new_resource)
          node.run_state['build_permission_command'] = files
        end
        action :nothing
        subscribes :run, 'bash[Install]', :immediate
      end
    end

    # Some install scripts create artifacts in the source directory
    def set_src_permissions(build_directory, new_resource)
      bash 'Set Config Permissions' do
        code "chown -R #{new_resource.owner}:#{new_resource.group} #{build_directory}"
        action :nothing
        subscribes :run, 'bash[Install]', :immediate
      end
    end

    def set_install_permissions(build_directory, new_resource)
      build_permission_command(new_resource)
      bash 'Change Install Permissions' do
        code(lazy { node.run_state['build_permission_command'] })
        cwd new_resource.install_directory
        action :nothing
        subscribes :run, 'bash[Install]', :immediate
      end
      set_src_permissions(build_directory, new_resource)
    end

    def make_build(build_directory, bin_file, new_resource)
      execute_build(build_directory, bin_file, new_resource)
      execute_install(build_directory, bin_file, new_resource)
      set_install_permissions(build_directory, new_resource)
    end

    def compile_and_install(build_directory, new_resource)
      check_build_directory(build_directory, new_resource)
      bin_file = File.join(new_resource.install_directory, install_creates_file(new_resource))
      manage_bin_file(bin_file)
      make_build(build_directory, bin_file, new_resource)
    end

    def build_binary(build_directory, new_resource)
      ensure_install_directory(new_resource)
      configure_build(build_directory, new_resource)
      compile_and_install(build_directory, new_resource)
      post_install_logic(new_resource)
    end

    def create_install(new_resource)
      ensure_version(new_resource)
      build_directory = path_to_build_directory(new_resource)
      extract_archive(build_directory, new_resource)
      build_binary(build_directory, new_resource)
    end
  end
end
