require 'test/unit'
require 'test/gemutilities'
require 'rubygems/installer'

class TestGemExtExtConfBuilder < RubyGemTestCase

  def setup
    super

    @ext = File.join @tempdir, 'ext'
    @dest_path = File.join @tempdir, 'prefix'

    FileUtils.mkdir_p @ext
    FileUtils.mkdir_p @dest_path
  end

  def test_class_build
    File.open File.join(@ext, 'extconf.rb'), 'w' do |extconf|
      extconf.puts "require 'mkmf'\ncreate_makefile 'foo'"
    end

    output = []

    Dir.chdir @ext do
      Gem::ExtExtConfBuilder.build 'extconf.rb', nil, @dest_path, output
    end

    expected = [
      "ruby extconf.rb",
      "creating Makefile\n",
      "make",
      "make: Nothing to be done for `all'.\n",
      "make install",
      "make: Nothing to be done for `install'.\n"
    ]

    assert_match(/^ruby extconf.rb/, output[0])
    assert_equal "creating Makefile\n", output[1]
    case RUBY_PLATFORM
    when /mswin/ then
      assert_equal "nmake", output[2]
      assert_equal "nmake install", output[4]
    else
      assert_equal "make", output[2]
      assert_equal "make install", output[4]
    end
  end

  def test_class_build_extconf_fail
    File.open File.join(@ext, 'extconf.rb'), 'w' do |extconf|
      extconf.puts "require 'mkmf'"
      extconf.puts "have_library 'nonexistent' or abort 'need libnonexistent'"
      extconf.puts "create_makefile 'foo'"
    end

    output = []

    error = assert_raise Gem::InstallError do
      Dir.chdir @ext do
        Gem::ExtExtConfBuilder.build 'extconf.rb', nil, @dest_path, output
      end
    end

    assert_match(/\Aextconf failed:

ruby extconf.rb.*
checking for main\(\) in .*?nonexistent/m, error.message)

    assert_match(/^ruby extconf.rb/, output[0])
  end

  def test_class_make
    output = []
    makefile_path = File.join(@ext, 'Makefile')
    File.open makefile_path, 'w' do |makefile|
      makefile.puts "RUBYARCHDIR = $(foo)$(target_prefix)"
      makefile.puts "RUBYLIBDIR = $(bar)$(target_prefix)"
      makefile.puts "all:"
      makefile.puts "install:"
    end

    Dir.chdir @ext do
      Gem::ExtExtConfBuilder.make @ext, output
    end

    case RUBY_PLATFORM
    when /mswin/ then
      assert_equal 'nmake', output[0]
      assert_equal 'nmake install', output[2]
    else
      assert_equal 'make', output[0]
      assert_equal 'make install', output[2]
    end

    edited_makefile = <<-EOF
RUBYARCHDIR = #{@ext}$(target_prefix)
RUBYLIBDIR = #{@ext}$(target_prefix)
all:
install:
    EOF

    assert_equal edited_makefile, File.read(makefile_path)
  end

  def test_class_make_no_Makefile
    error = assert_raise Gem::InstallError do
      Dir.chdir @ext do
        Gem::ExtExtConfBuilder.make @ext, ['output']
      end
    end

    expected = <<-EOF.strip
Makefile not found:

output
    EOF

    assert_equal expected, error.message
  end

end

