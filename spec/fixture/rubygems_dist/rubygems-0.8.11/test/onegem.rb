module OneGem

  ONEDIR = "test/data/one"
  ONENAME = "one-0.0.1.gem"
  ONEGEM = "#{ONEDIR}/#{ONENAME}"

  def clear
    FileUtils.rm_f ONEGEM
  end

  def build(controller)
    Dir.chdir(ONEDIR) do
      controller.gem "build one.gemspec"
    end
  end

  def rebuild(controller)
    clear
    build(controller)
  end

  extend self
end
