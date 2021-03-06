module GemInstaller
  class Config
    def initialize(yaml)
      @yaml = yaml
      @default_install_options_string = nil
    end

    def gems
      parse_defaults
      gem_defs = @yaml["gems"]
      gems = []
      gem_defs.each do |gem_def|
        name = gem_def['name']
        version = gem_def['version'].to_s
        platform = gem_def['platform'].to_s
        # get install_options for specific gem, if specified
        install_options_string = gem_def['install_options'].to_s
        # if no install_options were specified for specific gem, and default install_options were specified...
        if install_options_string.empty? &&
           !@default_install_options_string.nil? && 
           !@default_install_options_string.empty? then
          # then use the default install_options
          install_options_string = @default_install_options_string
        end
        install_options_array = []
        # if there was an install options string specified, default or gem-specific, parse it to an array
        install_options_array = install_options_string.split(" ") unless install_options_string.empty?

        check_for_upgrade = gem_def['check_for_upgrade']
        if check_for_upgrade.nil? && defined? @default_check_for_upgrade then
          check_for_upgrade = @default_check_for_upgrade
        end

        fix_dependencies = gem_def['fix_dependencies']
        if fix_dependencies.nil? && defined? @default_fix_dependencies then
          fix_dependencies = @default_fix_dependencies
        end

        no_autogem = gem_def['no_autogem']
        if no_autogem.nil? && defined? @default_no_autogem then
          no_autogem = @default_no_autogem
        end

        gem = GemInstaller::RubyGem.new(
          name, 
          :version => version, 
          :platform => platform, 
          :install_options => install_options_array, 
          :check_for_upgrade => check_for_upgrade,
          :no_autogem => no_autogem,
          :fix_dependencies => fix_dependencies)
        gems << gem
      end
      return gems
    end

    protected

    def parse_defaults
      defaults = @yaml["defaults"]
      return if defaults.nil?
      @default_install_options_string = defaults['install_options']
      @default_check_for_upgrade = defaults['check_for_upgrade']
      @default_fix_dependencies = defaults['fix_dependencies']
      @default_no_autogem = defaults['no_autogem']
    end
  end
end