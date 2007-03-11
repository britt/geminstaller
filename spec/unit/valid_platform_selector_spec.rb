dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../helper/spec_helper")

context "an ValidPlatformSelector with prefer_binary_platform == true and no dependent_gem_platform passed" do
  setup do
    @valid_platform_selector = GemInstaller::ValidPlatformSelector.new
    @valid_platform_selector.prefer_binary_platform = true
  end

  specify "should select RUBY_PLATFORM platform first, and default platform (ruby) last" do
    should_select_correct_valid_platforms("i686-darwin8.7.1", nil, ['686-darwin', 'ruby'])
    should_select_correct_valid_platforms("powerpc-darwin", nil, ['powerpc', 'ruby'])
    should_select_correct_valid_platforms("i386-mswin32", nil, ['mswin', 'ruby'])
    should_select_correct_valid_platforms("i686-linux", nil, ['686-linux', 'ruby'])
  end
end

context "an ValidPlatformSelector with prefer_binary_platform == true and some dependent_gem_platform passed" do
  setup do
    @valid_platform_selector = GemInstaller::ValidPlatformSelector.new
    @valid_platform_selector.prefer_binary_platform = true
  end

  specify "should select dependent_gem_platform first, RUBY_PLATFORM platform second, and default platform (ruby) last" do
    should_select_correct_valid_platforms("i686-darwin8.7.1", "some-other-platform", ['some-other-platform', '686-darwin', 'ruby'])
  end
end

context "an ValidPlatformSelector with prefer_binary_platform == false and no dependent_gem_platform passed" do
  setup do
    @valid_platform_selector = GemInstaller::ValidPlatformSelector.new
    @valid_platform_selector.prefer_binary_platform = false
  end

  specify "should select default platform (ruby) first, and RUBY_PLATFORM platform last" do
    should_select_correct_valid_platforms("i686-darwin8.7.1", nil, ['ruby', '686-darwin'])
  end
end

def should_select_correct_valid_platforms(ruby_platform, dependent_gem_platform, expected_valid_platforms)
  @valid_platform_selector.ruby_platform = ruby_platform
  valid_platforms = @valid_platform_selector.select(dependent_gem_platform)
  valid_platforms.should == expected_valid_platforms
end


