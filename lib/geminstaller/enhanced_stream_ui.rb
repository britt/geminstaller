module GemInstaller
  class EnhancedStreamUI < Gem::StreamUI
    attr_writer :noninteractive_chooser
    
    def initialize()
      @ins = InputQueue.new
      @outs = OutputObserver.new
      @errs = OutputObserver.new
    end
    
    def choose_from_list(question, list)
      @noninteractive_chooser.choose(question, list)
    end

    def register_outs_listener(listener)
      @outs.register(listener)
    end
    
    def unregister_outs_listener(listener)
      @outs.register(listener)
    end
    
    def register_errs_listener(listener)
      @errs.register(listener)
    end
    
    def unregister_errs_listener(listener)
      @errs.register(listener)
    end
    
    def queue_input(input)
      @ins.queue_input(input)
    end

    def terminate_interaction!(status=-1)
      raise GemInstaller::GemInstallerError.new("RubyGems exited abnormally.  Status: " + status + "\n")
    end
    
    def terminate_interaction(status=0)
      raise GemInstaller::RubyGemsExit.new(status)
    end

  end
  
  class OutputObserver
    def initialize
      @listeners = []
    end

    def register(listener)
      listener = [listener] unless listener.is_a?(Array)
      @listeners += listener
    end
    
    def unregister(listener)
      @listeners.delete(listener)
    end
    
    def print(output)
      @listeners.each do |listener|
        listener.notify(output)
      end
    end
    alias puts print
    
    def flush
    end
  end
  
  class InputQueue
    def initialize
      @queue = []
    end
    
    def queue_input(input)
      input = [input] unless input.is_a?(Array)
      @queue += input
    end
    
    def gets
      input = @queue.shift
      raise GemInstaller::GemInstallerError.new("GemInstaller Internal Error: No input queued for EnhancedStreamUI.") if input.nil?
      input
    end
  end
end