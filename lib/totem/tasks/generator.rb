module Totem
  module Tasks
    class Generator
      def migration(name)
        tstamp =  Time.now.utc.strftime("%Y%m%d%H%M%S")
        fname = "#{tstamp}_#{name}.rb"
        path = File.join(Totem.root, 'db', 'migrate', fname)

        name || raise('You must specify a name')

        puts "Creating migration: #{path}"

        if File.exists?(path)
          puts 'ERROR: File already exists.'
          return
        end

        content = <<-EOS.unindent
          class #{name.camelize} < ActiveRecord::Migration
          end
        EOS

        File.open(path, 'w') { |f| f.write(content) }

        return nil
      end
    end
  end
end
