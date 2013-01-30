module Totem
  module Tasks
    class Database
      def initialize
        @config = Totem.db_config.clone
      end

      def create
        options = { :charset => 'utf8', :collation => 'utf8_unicode_ci' }

        create_db = lambda do |config|
          ActiveRecord::Base.establish_connection(config.merge('database' => nil))
          ActiveRecord::Base.connection.create_database(config['database'], options)
          ActiveRecord::Base.establish_connection(config)
        end

        begin
          create_db.call(@config)
        rescue Mysql::Error => sqlerr
          if sqlerr.errno == 1405
            print "#{sqlerr.error}. \nPlease provide the root password for your mysql installation\n>"
            root_password = $stdin.gets.strip

            grant_statement = <<-SQL
              GRANT ALL PRIVILEGES ON #{config['database']}.*
                TO '#{config['username']}'@'localhost'
                IDENTIFIED BY '#{config['password']}' WITH GRANT OPTION;
            SQL

            create_db.call(@config.merge('database' => nil, 'username' => 'root', 'password' => root_password))
          else
            $stderr.puts sqlerr.error
            $stderr.puts "Couldn't create database for #{config.inspect}, charset: utf8, collation: utf8_unicode_ci"
            $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config['charset']
          end
        end

        Totem.db_reconnect

        return true
      end

      def drop
        ActiveRecord::Base.connection.drop_database(@config['database'])

        return true
      end

      def migrate
        ActiveRecord::Migration.verbose = true
        ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)

        Totem.db_reconnect

        return true
      end

      def rollback
        step = ENV['STEP'] ? ENV['STEP'].to_i : 1
        ActiveRecord::Migrator.rollback('db/migrate', step)

        Totem.db_reconnect

        return true
      end
    end
  end
end
