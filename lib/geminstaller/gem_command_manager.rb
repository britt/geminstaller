module GemInstaller
  class GemCommandManager
    attr_writer :gem_source_index_proxy, :gem_runner_proxy, :gem_interaction_handler
    
    def list_remote_gem(gem, additional_options)
      run_args = ["list",gem.name,"--remote"]
      run_args += additional_options
      @gem_runner_proxy.run(run_args)
    end

    def is_gem_installed?(gem)
      return local_matching_gem_specs(gem).size > 0
    end
    
    def local_matching_gem_specs(gem)
      @gem_source_index_proxy.refresh!
      gem_name_regexp = /^#{gem.regexp_escaped_name}$/
      found_gem_specs = @gem_source_index_proxy.search(gem_name_regexp,gem.version)
      return [] unless found_gem_specs
      matching_gem_specs = found_gem_specs.select do |gem_spec|
        gem_matches_spec?(gem, gem_spec)
      end
      return matching_gem_specs
    end
    
    def gem_matches_spec?(gem, gem_spec)
      if (gem.platform == Gem::Platform::CURRENT && gem_spec.platform = RUBY_PLATFORM) or
         gem_spec.platform == gem.platform
         platform_matches = true 
      end
      return gem_spec.name == gem.name && platform_matches
    end

    def uninstall_gem(gem)
      return if !is_gem_installed?(gem)
      @gem_interaction_handler.dependent_gem = gem
      run_gem_command('uninstall',gem)
    end

    def install_gem(gem)
      return if is_gem_installed?(gem)
      @gem_interaction_handler.dependent_gem = gem
      run_gem_command('install',gem)
    end
    
    def dependency(name, version, additional_options)
      # it would be great to use the dependency --pipe option, but unfortunately, rubygems has a bug
      # up to at least 0.9.2 where the pipe options uses 'puts', instead of 'say', so we can't capture it
      # with enhanced_stream_ui.  Patch submitted: 
      # http://rubyforge.org/tracker/index.php?func=detail&aid=9020&group_id=126&atid=577
      run_args = ["dependency",/^#{name}$/,"--version",version]
      run_args += additional_options
      output_lines = @gem_runner_proxy.run(run_args)
      # dependency output has all lines in the first element
      output_array = output_lines[0].split("\n")
      # drop the first line which just echoes the dependent gem
      output_array.shift
      # drop the line containing 'requires' (rubygems < 0.9.0)
      if output_array[0] == '  Requires'
        output_array.shift
      end
      # drop all empty lines
      output_array.reject! { |line| line == "" }
      # strip leading space
      output_array.each { |line| line.strip! }
      output_array
    end

    def run_gem_command(gem_command,gem)
      run_args = [gem_command,gem.name,"--version", "#{gem.version}"]
      run_args += gem.install_options
      @gem_runner_proxy.run(run_args)
    end
  end
end





