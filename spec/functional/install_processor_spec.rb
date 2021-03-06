dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../helper/spec_helper")

describe "an InstallProcessor instance" do
  before(:each) do
    GemInstaller::TestGemHome.use
    @registry = GemInstaller::create_registry
    @install_processor = @registry.install_processor
    @mock_output_filter = mock("Mock Output Filter")
    @install_processor.output_filter = @mock_output_filter

    @missing_dependency_finder = @registry.missing_dependency_finder
    @missing_dependency_finder.output_filter = @mock_output_filter

    @gem_command_manager = @registry.gem_command_manager
    @gem_spec_manager = @registry.gem_spec_manager
    @sample_gem = sample_gem
    @sample_dependent_gem = sample_dependent_gem
    @sample_multiplatform_gem = sample_multiplatform_gem_ruby
    @sample_dependent_multiplatform_gem = sample_dependent_multiplatform_gem
    @sample_dependent_multilevel_gem = sample_dependent_multilevel_gem

    # ensure all gems are installed to start
    [@sample_gem, @sample_dependent_gem, @sample_dependent_multilevel_gem].each do |gem|
      gem.fix_dependencies = true
      install_gem(gem)
    end
  end

  it "should install a missing dependency at the bottom of a multilevel dependency chain" do
    # uninstall ONLY the dependency
    @sample_gem.uninstall_options -= ['--all']
    uninstall_gem(@sample_gem)

    @mock_output_filter.should_receive(:geminstaller_output).once.with(:debug,/^Gem #{@sample_dependent_multilevel_gem.name}, version 1.0.0 is already installed/m)

    if GemInstaller::RubyGemsVersionChecker.matches?('>=0.9.5')
      # Rubygems >= 0.9.5 automatically installs missing dependencies by reinstalling top-level gem
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/fix_dependencies.*#{@sample_dependent_multilevel_gem.name}.*will be reinstalled/m)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Invoking gem install for #{@sample_dependent_multilevel_gem.name}, version 1.0.0/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Rubygems automatically installed dependency gem #{@sample_gem.name}-#{@sample_gem.version}/)
    else
      # GemInstaller handles missing dependencies for older versions, but doesn't perform re-install of top-level gem
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:info,/^Missing dependencies found for #{@sample_dependent_gem.name} \(1.0.0\)/m)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:info,/^  #{@sample_gem.name} \(>= 1.0.0\)/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Installing #{@sample_gem.name} \(>= 1.0.0\)/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Invoking gem install for #{@sample_gem.name}, version 1.0.0/)
    end


    @install_processor.process([@sample_dependent_multilevel_gem])
    @gem_spec_manager.is_gem_installed?(@sample_gem).should==(true)
  end
  
  it "should install missing dependencies in middle and bottom of a multilevel dependency chain" do
    # uninstall the dependencies
    [@sample_gem, @sample_dependent_gem].each do |gem|
      gem.uninstall_options -= ['--all']
      uninstall_gem(gem)
    end
  
    options = {:info => true}
    @install_processor.options = options
  
    @mock_output_filter.should_receive(:geminstaller_output).once.with(:debug,/^Gem #{@sample_dependent_multilevel_gem.name}, version 1.0.0 is already installed/m)
    if GemInstaller::RubyGemsVersionChecker.matches?('>=0.9.5')
      # Rubygems >= 0.9.5 automatically installs missing dependencies by reinstalling top-level gem
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/fix_dependencies.*#{@sample_dependent_multilevel_gem.name}.*will be reinstalled/m)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Invoking gem install for #{@sample_dependent_multilevel_gem.name}, version 1.0.0/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Rubygems automatically installed dependency gem #{@sample_dependent_gem.name}-#{@sample_dependent_gem.version}/)
    else
      # GemInstaller handles missing dependencies for older versions, but doesn't perform re-install of top-level gem
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:info,/^Missing dependencies found for #{@sample_dependent_multilevel_gem.name} \(1.0.0\)/m)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:info,/^  #{@sample_dependent_gem.name} \(>= 1.0.0\)/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Installing #{@sample_dependent_gem.name} \(>= 1.0.0\)/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Invoking gem install for #{@sample_dependent_gem.name}, version 1.0.0/)
    end
  
    # TODO: info option results in duplicate installation messages
    @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Rubygems automatically installed dependency gem #{@sample_gem.name}-#{@sample_gem.version}/)
  
    @install_processor.process([@sample_dependent_multilevel_gem])
    @gem_spec_manager.is_gem_installed?(@sample_dependent_gem).should==(true)
    @gem_spec_manager.is_gem_installed?(@sample_gem).should==(true)
  end
  
  it "should install missing dependencies at top and bottom of a multilevel dependency chain" do
    # uninstall the gems
    [@sample_gem, @sample_dependent_multilevel_gem].each do |gem|
      gem.uninstall_options -= ['--all']
      uninstall_gem(gem)
    end
  
    @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Invoking gem install for #{@sample_dependent_multilevel_gem.name}, version 1.0.0/)
  
    if GemInstaller::RubyGemsVersionChecker.matches?('>=0.9.5')
      # Rubygems >= 0.9.5 automatically installs missing dependencies
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Rubygems automatically installed dependency gem #{@sample_gem.name}-1.0.0/m)
    else
      # GemInstaller handles missing dependencies for older versions
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:info,/^Missing dependencies found for #{@sample_dependent_gem.name} \(1.0.0\)/m)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:info,/^  #{@sample_gem.name} \(>= 1.0.0\)/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Invoking gem install for #{@sample_gem.name}, version 1.0.0/)
      @mock_output_filter.should_receive(:geminstaller_output).once.with(:install,/^Installing #{@sample_gem.name} \(>= 1.0.0\)/)
    end
  
  
    # middle level should already be installed
    @gem_spec_manager.is_gem_installed?(@sample_dependent_gem).should==(true)
  
    @install_processor.process([@sample_dependent_multilevel_gem])
    #top level should be installed
    @gem_spec_manager.is_gem_installed?(@sample_dependent_multilevel_gem).should==(true)
    #bottom level should be installed
    @gem_spec_manager.is_gem_installed?(@sample_gem).should==(true)
  end
  
  after(:each) do
    GemInstaller::TestGemHome.uninstall_all_test_gems
  end

  def uninstall_gem(gem)
    @gem_command_manager.uninstall_gem(gem)
    @gem_spec_manager.is_gem_installed?(gem).should==(false)
  end  
end
