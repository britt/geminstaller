# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{geminstaller}
  s.version = "0.5.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chad Woolley", "Britt Crawford", "Mike Pearce"]
  s.date = %q{2009-06-22}
  s.description = %q{Automated Gem installation, activation, and much more!  == FEATURES:  GemInstaller provides automated installation, loading and activation of RubyGems.  It uses a simple YAML config file to:  * Automatically install the correct versions of all required gems wherever your app runs. * Automatically ensure installed gems and versions are consistent across multiple applications, machines, platforms, and environments  * Automatically activate correct versions of gems on the ruby load path when your app runs ('require_gem'/'gem') * Automatically reinstall missing dependency gems (built in to RubyGems &gt; 1.0) * Automatically detect correct platform to install for multi-platform gems (built in to RubyGems &gt; 1.0) * Print YAML for \"rogue gems\" which are not specified in the current config, to easily bootstrap your config file, or find gems that were manually installed without GemInstaller. * Allow for common configs to be reused across projects or environments by supporting multiple config files, including common config file snippets, and defaults with overrides. * Allow for dynamic selection of gems, versions, and platforms to be used based on environment vars or any other logic. * Avoid the \"works on demo, breaks on production\" syndrome * Solve world hunger, prevent the global energy crisis, and wash your socks.  == SYNOPSYS:}
  s.email = %q{thewoolleyman@gmail.com}
  s.has_rdoc = true
  s.homepage = %q{http://geminstaller.rubyforge.org/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.files = [".loadpath", "COPYING", "History.txt", "LICENSE", "Manifest.txt", "README.txt", "Rakefile", "TODO.txt", "bin/geminstaller", "cruise_config.rb", "focused_spec.sh", "focused_spec_debug.sh", "geminstaller.yml", "lib/geminstaller.rb", "lib/geminstaller/application.rb", "lib/geminstaller/arg_parser.rb", "lib/geminstaller/autogem.rb", "lib/geminstaller/backward_compatibility.rb", "lib/geminstaller/config.rb", "lib/geminstaller/config_builder.rb", "lib/geminstaller/enhanced_stream_ui.rb", "lib/geminstaller/exact_match_list_command.rb", "lib/geminstaller/file_reader.rb", "lib/geminstaller/gem_arg_processor.rb", "lib/geminstaller/gem_command_manager.rb", "lib/geminstaller/gem_interaction_handler.rb", "lib/geminstaller/gem_list_checker.rb", "lib/geminstaller/gem_runner_proxy.rb", "lib/geminstaller/gem_source_index_proxy.rb", "lib/geminstaller/gem_spec_manager.rb", "lib/geminstaller/geminstaller_access_error.rb", "lib/geminstaller/geminstaller_error.rb", "lib/geminstaller/hoe_extensions.rb", "lib/geminstaller/install_processor.rb", "lib/geminstaller/missing_dependency_finder.rb", "lib/geminstaller/missing_file_error.rb", "lib/geminstaller/noninteractive_chooser.rb", "lib/geminstaller/output_filter.rb", "lib/geminstaller/output_listener.rb", "lib/geminstaller/output_observer.rb", "lib/geminstaller/output_proxy.rb", "lib/geminstaller/registry.rb", "lib/geminstaller/requires.rb", "lib/geminstaller/rogue_gem_finder.rb", "lib/geminstaller/ruby_gem.rb", "lib/geminstaller/rubygems_exit.rb", "lib/geminstaller/rubygems_extensions.rb", "lib/geminstaller/rubygems_version_checker.rb", "lib/geminstaller/rubygems_version_warnings.rb", "lib/geminstaller/source_index_search_adapter.rb", "lib/geminstaller/unauthorized_dependency_prompt_error.rb", "lib/geminstaller/unexpected_prompt_error.rb", "lib/geminstaller/valid_platform_selector.rb", "lib/geminstaller/version_specifier.rb", "lib/geminstaller/yaml_loader.rb", "lib/geminstaller_rails_preinitializer.rb", "start_local_gem_server.sh", "test/test_all.rb", "test/test_all_smoketests.rb", "website/config.yaml", "website/src/analytics.page", "website/src/code/ci.virtual", "website/src/code/coverage/index.virtual", "website/src/code/index.page", "website/src/code/rdoc/index.virtual", "website/src/community/index.page", "website/src/community/links.page", "website/src/community/rubyforge.virtual", "website/src/default.css", "website/src/default.template", "website/src/documentation/documentation.page", "website/src/documentation/index.page", "website/src/documentation/tutorials.page", "website/src/download.page", "website/src/faq.page", "website/src/index.page", "website/src/metainfo", "website/src/webgen.css"]
  s.bindir = %q{bin}
  s.executables = ['geminstaller']
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{geminstaller}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Automated Gem installation, activation, and much more!}

  s.add_dependency(%q<mime-types>, [">= 1.15"])
  s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
  s.add_dependency(%q<hoe>, [">= 1.8.3"])
  s.add_dependency(%q<open4>, [">= 0.9.6"])
  s.add_dependency(%q<rake>, [">= 0.7.1"])
  s.add_dependency(%q<rcov>, [">= 0.7.0.1"])
  s.add_dependency(%q<RedCloth>, ["= 4.0.4"])
  s.add_dependency(%q<rspec>, [">= 1.1.12"])
  s.add_dependency(%q<cmdparse>, [">= 2.0.2"])
  s.add_dependency(%q<ruby-debug>, [">= 0.9.3"])
  s.add_dependency(%q<webgen>, [">= 0.5.5"])
end
