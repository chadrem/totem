require 'irb'

module Totem
  module ShellCmds
    class Console < Totem::ShellCmds::Base
      def run
        ARGV.clear
        IRB.start
      end
    end
  end
end

Totem::Shell.register_cmd(:console, Totem::ShellCmds::Console)
