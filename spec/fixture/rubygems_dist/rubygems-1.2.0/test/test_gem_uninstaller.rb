require File.join(File.expand_path(File.dirname(__FILE__)),
                  'gem_installer_test_case')
require 'rubygems/uninstaller'

class TestGemUninstaller < GemInstallerTestCase

  def setup
    super

    ui = MockGemUi.new
    util_setup_gem ui

    use_ui ui do
      @installer.install
    end
  end

  def test_initialize_expand_path
    uninstaller = Gem::Uninstaller.new nil, :install_dir => '/foo//bar'

    assert_match %r|/foo/bar$|, uninstaller.instance_variable_get(:@gem_home)
  end

  def test_remove_executables_force_keep
    uninstaller = Gem::Uninstaller.new nil, :executables => false

    use_ui @ui do
      uninstaller.remove_executables @spec
    end

    assert_equal true, File.exist?(File.join(@gemhome, 'bin', 'executable'))

    assert_equal "Executables and scripts will remain installed.\n", @ui.output
  end

  def test_remove_executables_force_remove
    uninstaller = Gem::Uninstaller.new nil, :executables => true

    use_ui @ui do
      uninstaller.remove_executables @spec
    end

    assert_equal "Removing executable\n", @ui.output

    assert_equal false, File.exist?(File.join(@gemhome, 'bin', 'executable'))
  end

  def test_path_ok_eh
    uninstaller = Gem::Uninstaller.new nil

    assert_equal true, uninstaller.path_ok?(@spec)
  end

  def test_path_ok_eh_legacy
    uninstaller = Gem::Uninstaller.new nil

    @spec.loaded_from.gsub! @spec.full_name, '\&-legacy'
    @spec.platform = 'legacy'

    assert_equal true, uninstaller.path_ok?(@spec)
  end

end

