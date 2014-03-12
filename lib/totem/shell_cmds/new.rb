require 'fileutils'

module Totem
  module ShellCmds
    class New < Totem::ShellCmds::Base
      def run
        if @args[0].nil?
          puts "You must provide a name for the new project."
          return
        end

        root_path = @args[0] + '/'

        puts 'Creating project root directory...'
        Dir.mkdir(root_path)
        puts

        puts 'Creating sub-directories...'
        %w(app config log tmp).each do |dir|
          puts "  #{dir}..."
          Dir.mkdir(root_path + dir)
        end
        puts

        template_path = File.expand_path(File.dirname(__FILE__) + '/../../../')

        puts 'Creating Gemfile...'
        FileUtils.cp(template_path + 'Gemfile.erb', root_path + 'Gemfile')
        puts

        puts 'Creating config/environment.rb...'
        FileUtils.cp(template_path + 'config/environment.rb.erb', root_path + 'config/environment.rb')
        puts

        puts 'Creating app/loader.rb...'
        FileUtils.cp(template_path + 'app/loader.rb.erb', root_path + 'app/loader.rb')
        puts

        puts 'Finished! You must now run "bundle update" inside your project directory.'
      end

    end
  end
end

Totem::Shell.register_cmd(:new, Totem::ShellCmds::New)
