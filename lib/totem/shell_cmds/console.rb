require 'irb'

module Totem
  module ShellCmds
    class Console < Totem::ShellCmds::Base
      def run
        env_path = 'config/environment.rb'
        if File.exists?(env_path)
          load(env_path)
        else
          puts "Unable to find #{env_path}.  You must run this command from your project root directory."
          exit
        end

        ARGV.clear
        IRB.start
      end
    end
  end
end

Totem::Shell.register_cmd(:console, Totem::ShellCmds::Console)
