require 'erb'

module Totem
  module ShellCmds
    class New < Totem::ShellCmds::Base
      def run
        if @args[0].nil?
          puts "You must provide a name for the new project."
          return
        end

        root_path = @args[0]

        puts 'Creating project root directory...'
        Dir.mkdir(root_path)
        puts

        puts 'Creating sub-directories...'
        %w(app config log tmp).each do |dir|
          puts "  #{dir}..."
          Dir.mkdir(root_path + '/' + dir)
        end
        puts

        template_path = File.expand_path(File.dirname(__FILE__) + '/../../../templates')

        puts 'Creating Gemfile...'
        input = File.read(template_path + '/Gemfile.erb')
        output = ERB.new(input).result(binding)
        File.open(root_path + '/Gemfile', 'w') { |f| f.write(output) }
        puts

        puts 'Creating config/environment.rb...'
        input = File.read(template_path + '/config/environment.rb.erb')
        output = ERB.new(input).result(binding)
        File.open(root_path + '/config/environment.rb', 'w') { |f| f.write(output) }
        puts

        puts 'Creating app/loader.rb...'
        input = File.read(template_path + '/app/loader.rb.erb')
        output = ERB.new(input).result(binding)
        File.open(root_path + '/app/loader.rb', 'w') { |f| f.write(output) }
        puts

        puts 'Finished! You must now run "bundle update" inside your project directory.'
      end

    end
  end
end

Totem::Shell.register_cmd(:new, Totem::ShellCmds::New)
