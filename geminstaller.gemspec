# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{geminstaller}
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chad Woolley", "Britt Crawford", "Mike Pearce"]
  s.date = %q{2009-06-22}
  s.description = %q{Automated Gem installation, activation, and much more!  == FEATURES:  GemInstaller provides automated installation, loading and activation of RubyGems.  It uses a simple YAML config file to:  * Automatically install the correct versions of all required gems wherever your app runs. * Automatically ensure installed gems and versions are consistent across multiple applications, machines, platforms, and environments  * Automatically activate correct versions of gems on the ruby load path when your app runs ('require_gem'/'gem') * Automatically reinstall missing dependency gems (built in to RubyGems &gt; 1.0) * Automatically detect correct platform to install for multi-platform gems (built in to RubyGems &gt; 1.0) * Print YAML for \"rogue gems\" which are not specified in the current config, to easily bootstrap your config file, or find gems that were manually installed without GemInstaller. * Allow for common configs to be reused across projects or environments by supporting multiple config files, including common config file snippets, and defaults with overrides. * Allow for dynamic selection of gems, versions, and platforms to be used based on environment vars or any other logic. * Avoid the \"works on demo, breaks on production\" syndrome * Solve world hunger, prevent the global energy crisis, and wash your socks.  == SYNOPSYS:}
  s.email = %q{thewoolleyman@gmail.com}
  s.has_rdoc = true
  s.homepage = %q{http://geminstaller.rubyforge.org/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
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
