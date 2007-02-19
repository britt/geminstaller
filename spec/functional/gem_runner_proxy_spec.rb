dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../spec_helper")

context "a GemRunnerProxy instance" do
  include GemInstaller::SpecUtils
  setup do
    GemInstaller::SpecUtils::TestGemHome.use
    @registry = GemInstaller::create_registry
    @gem_runner_proxy = @registry.gem_runner_proxy
    @noninteractive_chooser = @registry.noninteractive_chooser
    
    GemInstaller::SpecUtils::EmbeddedGemServer.start
  end

  teardown do
    GemInstaller::SpecUtils::TestGemHome.reset
  end

  specify "should return output of gem command" do
    gem_runner_args = ["list", "#{sample_multiplatform_gem_name}", "--remote"]
    gem_runner_args += install_options_for_testing

    output = @gem_runner_proxy.run(gem_runner_args)
    expected_output = /#{sample_multiplatform_gem_name} \(#{sample_multiplatform_gem_version}, #{sample_multiplatform_gem_version_low}\)/m
    output.join("\n").should_match(expected_output)
  end

  specify "should choose from list" do
    gem_runner_args = ["install", "#{sample_multiplatform_gem_name}", "--remote"]
    gem_runner_args += install_options_for_testing

    @noninteractive_chooser.specify_exact_gem_spec(sample_multiplatform_gem_name, sample_multiplatform_gem_version, 'mswin32')
    output = @gem_runner_proxy.run(gem_runner_args)
    output.join("\n").should_match(/Successfully installed #{sample_multiplatform_gem_name}-#{sample_multiplatform_gem_version}-mswin32/m)
  end
end