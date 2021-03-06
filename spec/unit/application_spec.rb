dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../helper/spec_helper")

describe "an application instance invoked with no args" do
  before(:each) do
    application_spec_setup_common
    @mock_arg_parser.should_receive(:parse).with(nil)
    @mock_arg_parser.should_receive(:output).and_return(nil)
  end
  
  it "should install a gem which is specified in the config and print startup message" do
    @mock_config_builder.should_receive(:build_config).and_return {@stub_config_local}
    
    gems = [@stub_gem]
    @stub_config.should_receive(:gems).and_return(gems)
    @mock_install_processor.should_receive(:process).once.with(gems)
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:debug,/^GemInstaller is verifying gem installation: gemname 1.0/)
    @application.install
  end

  it "should install multiple gems which are specified in the config and print startup message" do
    @mock_config_builder.should_receive(:build_config).and_return {@stub_config_local}
    
    @stub_gem2 = GemInstaller::RubyGem.new("gemname2")
    gems = [@stub_gem, @stub_gem2]
    @stub_config.should_receive(:gems).and_return(gems)
    @mock_install_processor.should_receive(:process).once.with(gems)
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:debug,/^GemInstaller is verifying gem installation: gemname 1.0, gemname2 > 0.0.0/)
    @application.install
  end

  it "should not install a gem which is already installed" do
    @mock_config_builder.should_receive(:build_config).and_return {@stub_config_local}
    
    @stub_gem.check_for_upgrade = false
    gems = [@stub_gem]
    @stub_config.should_receive(:gems).and_return(gems)
    @mock_install_processor.should_receive(:process).once.with(gems)
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:debug,/^GemInstaller is verifying gem installation/)
    @application.install
  end

  it "should verify and specify gem if check_for_upgrade is specified" do
    @mock_config_builder.should_receive(:build_config).and_return {@stub_config_local}
    
    @stub_gem.check_for_upgrade = true
    gems = [@stub_gem]
    @stub_config.should_receive(:gems).and_return(gems)
    @mock_install_processor.should_receive(:process).once.with(gems)
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:debug,/^GemInstaller is verifying gem installation/)
    @application.install
  end

  it "should print any exception message to debug then exit gracefully" do
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:error,/^GemInstaller::GemInstallerError/)
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:debug,anything())
    @mock_config_builder.should_receive(:build_config).and_raise(GemInstaller::GemInstallerError)
    return_code = @application.install
    return_code.should ==(1)
  end

  it "should print any exception message AND stacktrace" do
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:error,/^GemInstaller::GemInstallerError/)
    @mock_output_filter.should_receive(:geminstaller_output).once() # TODO: how to specify Error/stacktrace exception?
    @mock_config_builder.should_receive(:build_config).and_raise(GemInstaller::GemInstallerError)
    return_code = @application.install
    return_code.should==(1)
  end

  it ", with --exceptions option, should raise any exception" do
    @options[:exceptions] = true
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:error,/^GemInstaller::GemInstallerError/)
    @mock_output_filter.should_receive(:geminstaller_output).once() # TODO: how to specify Error/stacktrace exception?
    @mock_config_builder.should_receive(:build_config).and_raise(GemInstaller::GemInstallerError)
    lambda { @application.install }.should raise_error(GemInstaller::GemInstallerError)
  end
end

describe "an application instance invoked with invalid args or help option" do
  before(:each) do
    application_spec_setup_common
  end

  it "should print any arg parser error output then exit gracefully" do
    arg_parser_output = "arg parser output"
    @mock_output_filter.should_receive(:geminstaller_output).with(:error,/^arg parser output/)
    @mock_arg_parser.should_receive(:parse).with(nil).and_return(1)
    @mock_arg_parser.should_receive(:output).and_return(arg_parser_output)
    return_code = @application.install
    return_code.should==(1)
  end

  it "should print any arg parser non-error output then exit gracefully" do
    arg_parser_output = "arg parser output"
    @mock_output_filter.should_receive(:geminstaller_output).with(:info,/^arg parser output/)
    @mock_arg_parser.should_receive(:parse).with(nil).and_return(0)
    @mock_arg_parser.should_receive(:output).and_return(arg_parser_output)
    return_code = @application.install
    return_code.should==(0)
  end
end

describe "an application instance invoked with missing config file(s)" do
  before(:each) do
    application_spec_setup_common
  end

  it "should print message and exit gracefully" do
    @mock_output_filter.should_receive(:geminstaller_output).with(:error,/^Error: A GemInstaller config file is missing/m)
    @mock_output_filter.should_receive(:geminstaller_output).once().with(:debug,anything())
    @mock_arg_parser.should_receive(:parse).with(nil).and_return(0)
    @mock_arg_parser.should_receive(:output).and_return('')
    @mock_config_builder.should_receive(:build_config).and_raise(GemInstaller::MissingFileError)
    return_code = @application.install
    return_code.should==(1)
  end
  
  it "should still run print-rogue-gems option if it is specified and there is only a single config file" do
    @options[:print_rogue_gems] = true
    @mock_arg_parser.should_receive(:parse).with(nil).and_return(0)
    @mock_arg_parser.should_receive(:output).and_return('')
    @mock_config_builder.should_receive(:build_config).and_raise(GemInstaller::MissingFileError)
    single_config = ['single_config_file.yml']
    @mock_config_builder.should_receive(:config_file_paths_array).twice.and_return(single_config)
    @mock_rogue_gem_finder.should_receive(:print_rogue_gems).once().with([], single_config)
    return_code = @application.install
    return_code.should==(0)
  end

  it "should not run print-rogue-gems option if there is more than one missing config file" do
  end
end

describe "an application instance invoked with alternate config file location" do
  before(:each) do
    application_spec_setup_common
    @mock_output_filter.should_receive(:geminstaller_output).with(:debug,anything())
  end

  it "should use the alternate config file location" do
    config_paths = 'config_paths'
    @mock_arg_parser.should_receive(:parse).with(nil)
    @options[:config_paths] = config_paths
    @mock_arg_parser.should_receive(:output)
    @mock_config_builder.should_receive(:config_file_paths=).with(config_paths).and_return {@stub_config_local}
    @mock_config_builder.should_receive(:build_config).and_return {@stub_config_local}
    
    gems = [@stub_gem]
    @stub_config.should_receive(:gems).and_return(gems)
    @mock_install_processor.should_receive(:process).once.with(gems)
    @application.install
  end
end

describe "an application instance invoked with print-rogue-gems arg" do
  before(:each) do
    application_spec_setup_common
    @mock_arg_parser.should_receive(:parse).with(nil)
    @mock_arg_parser.should_receive(:output).and_return(nil)
    @options[:print_rogue_gems] = true
  end

  it "should invoke rogue_gem_finder" do
    
    @mock_config_builder.should_receive(:build_config).and_return {@stub_config_local}
    
    gems = [@stub_gem]
    @stub_config.should_receive(:gems).and_return(gems)
    
    paths = []
    @mock_config_builder.should_receive(:config_file_paths_array).once.and_return(paths)
    @mock_rogue_gem_finder.should_receive(:print_rogue_gems).once().with(gems, paths)
    
    @application.install
  end
end

def application_spec_setup_common
  @mock_arg_parser = mock("Mock Arg Parser")
  @mock_config_builder = mock("Mock Config Builder")
  @stub_config = mock("Mock Config")
  @mock_install_processor = mock("Mock InstallProcessor")
  @mock_output_filter = mock("Mock Output Filter")
  @stub_gem = GemInstaller::RubyGem.new("gemname", :version => "1.0")
  @mock_rogue_gem_finder = mock("Mock RogueGemFinder")
  @options = {}

  @stub_config_local = @stub_config

  @application = GemInstaller::Application.new
  @application.options = @options
  @application.arg_parser = @mock_arg_parser
  @application.config_builder = @mock_config_builder
  @application.install_processor = @mock_install_processor
  @application.output_filter = @mock_output_filter
  @application.rogue_gem_finder = @mock_rogue_gem_finder
end


