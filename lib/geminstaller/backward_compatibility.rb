# this file supports backward compatibility for prior versions of RubyGems

# 0.9.3 reorganized commands to Gem::Commands:: module from Gem::
if GemInstaller::RubyGemsVersionChecker.matches?('<0.9.3')
  LIST_COMMAND_CLASS = Gem::ListCommand
  QUERY_COMMAND_CLASS = Gem::QueryCommand
else
  LIST_COMMAND_CLASS = Gem::Commands::ListCommand
  QUERY_COMMAND_CLASS = Gem::Commands::QueryCommand
end
