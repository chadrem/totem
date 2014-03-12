module Totem
  module ShellCmds
    class New < Totem::ShellCmds::Base
      def run
        if @args[0].nil?
          puts "You must provide a name for the new project."
          return
        end

        puts "Creating project root directory..."
        Dir.mkdir(@args[0])

        puts "Switching to project root directory..."
        Dir.chdir(@args[0])

        %w(app config log).each do |dir|
          puts "Creating project sub-directory (#{dir})..."
          Dir.mkdir(dir)
        end
      end
    end
  end
end

Totem::Shell.register_cmd(:new, Totem::ShellCmds::New)
