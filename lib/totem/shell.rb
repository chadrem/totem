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
