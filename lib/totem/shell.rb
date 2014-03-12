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
      if @args[0].nil?
        puts "Usage: totem <command>"
        puts "Available commands: #{self.class.cmds.keys.join(', '}"
        return
      end

      cmd_to_class(@args[0]).new(@args[1..-1]).run
    end

    private

    def self.cmds
      return @cmds
    end

    def cmd_to_class(cmd)
      return self.class.cmds[cmd.to_sym] || raise("Unknown cmd: #{cmd}")
    end
  end
end
