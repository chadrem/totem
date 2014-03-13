module Totem
  class Shell
    @cmds = {}

    def self.register_cmd(cmd, klass)
      @cmds[cmd.to_sym] = klass

      return nil
    end

    def initialize(args)
      @args = args
    end

    def run
      env_path = 'config/environment.rb'
      if File.exists?(env_path)
        load(env_path)
      else
        puts "Unable to find #{env_path}.  You must run this command from your project root directory."
        exit
      end

      if @args[0].nil?
        puts_usage
        return
      end

      cmd_to_class(@args[0]).new(@args[1..-1]).run
    end

    private

    def self.cmds
      return @cmds
    end

    def cmd_to_class(cmd)
      if result = self.class.cmds[cmd.to_sym]
        return result
      end

      puts "ERROR: Unknown command: #{cmd}"
      puts
      puts_usage

      exit
    end

    private

    def puts_usage
      puts "Usage:\n  bundle exec totem <command>"
      puts
      puts "Commands:\n  #{self.class.cmds.keys.join(', ')}"
    end
  end
end
