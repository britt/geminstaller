module GemInstaller::SpecUtils
  SUPPRESS_RUBYGEMS_OUTPUT = false
  
  def self.test_gem_home
    # TODO: This dir name is duplicated in test_rubygems_config_file.  We would have to 
    # dynamically generate that file to remove the duplication
    dir_name = "test_gem_home.tmp"
    File.dirname(__FILE__) + "/#{dir_name}"
  end
  
  def self.test_rubygems_config_file
    file_name = "test_gem.rc"
    File.dirname(__FILE__) + "/#{file_name}"
  end
  
  def sample_gem_name
    sample_gem_name = "stubgem"
  end

  def sample_gem_version
    sample_gem_version = "1.0.0"
  end

  def sample_multiplatform_gem_name
    sample_gem_name = "stubgem-multiplatform"
  end

  def sample_multiplatform_gem_version
    sample_gem_version = "1.0.1"
  end
  
  def local_gem_server_port
    9909
  end

  def local_gem_server_url
    "http://127.0.0.1:#{local_gem_server_port}"
  end
  
  def install_options_for_testing
    ['--source', local_gem_server_url, '--config-file', GemInstaller::SpecUtils.test_rubygems_config_file]
  end
  
  def sample_gem(install_options=install_options_for_testing)
    GemInstaller::RubyGem.new(sample_gem_name, :version => sample_gem_version, :install_options => install_options)
  end
  
  def sample_multiplatform_gem(install_options=install_options_for_testing)
    GemInstaller::RubyGem.new(sample_multiplatform_gem_name, :version => sample_multiplatform_gem_version, :platform => 'mswin32', :install_options => install_options)
  end
  
  def proc_should_raise_with_message(message_regex, &block)
    error = nil
    p GemInstaller::GemInstallerError
    lambda {
      begin
        block.call
      rescue GemInstaller::GemInstallerError => error
        raise error
      end
      }.should_raise GemInstaller::GemInstallerError
      error.message.should_match(message_regex)
  end
  
  
  class EmbeddedGemServer
    @@gem_server_pid = nil
    def self.start
      return if @@gem_server_pid
      Gem.clear_paths
      gem_server_process = IO.popen("gem_server --dir=#{embedded_gem_dir} --port=9909")
      @@gem_server_pid = gem_server_process.pid
      print "Started embedded gem server at #{embedded_gem_dir}, pid = #{@@gem_server_pid}\n"
      trap("INT") { Process.kill(9,@@gem_server_pid); exit! }
      # TODO: avoid sleep by detecting when gem_server port comes up
      sleep 3
    end
    
    def self.embedded_gem_dir
      File.dirname(__FILE__) + "/gems"
    end
    
    def self.stop
      stopped = false
      if @@gem_server_pid
        print "Killing embedded gem server at pid = #{@@gem_server_pid}\n"
        begin
          Process.kill(9,@@gem_server_pid)
        rescue
          puts "Warning: The embedded gem_server process may not have been stopped.  You may need to kill it manually..."          
        end
        stopped = true
      end
      return stopped
    end
  end
  
  class TestGemHome
    include FileUtils
    
    def self.init_dir
      FileUtils.rm_rf(dir)
      FileUtils.mkdir(dir)
    end

    def self.dir
      GemInstaller::SpecUtils.test_gem_home
    end
    
    def self.config_file
      GemInstaller::SpecUtils.test_rubygems_config_file
    end
    
    def self.use
      init_dir
      rm_config
      create_config
      # TODO: is the use_paths even necessary if you set the config file???
      # Gem.use_paths(dir)
    end
    
    def self.rm_config
      FileUtils.rm(config_file) if File.exist?(config_file)
    end
    
    def self.create_config
      file = File.open(config_file, "w") do |f| 
        f << "gempath:\n"
        f << "  - #{Gem.default_dir}\n"
        f << "gemhome: #{dir}\n"
      end 
    end

    def self.reset
      Gem.clear_paths
      rm_config
    end
  end
end