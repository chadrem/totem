require 'tribe'
require 'tribe_em'

require 'totem/version'
require 'totem/tasks/console'
require 'totem/tasks/database'
require 'totem/tasks/generator'
require 'totem/actable'
require 'totem/connection'
require 'totem/tcp_server'

module Totem
  def self.initialize(root)
    raise 'Already initialized.' if @setup

    @setup = true
    @root = root

    Bundler.require(Totem.env.to_sym)
    Time.zone = 'UTC'
    db_connect
    load_app

    return true
  end

  def self.root
    return @root
  end

  def self.env
    return (@env ||= (ENV['GAME_SRV_ENV'] || 'development'))
  end

  def self.settings
    return @settings if @settings

    begin
      @settings = Fiona::Settings.new do |s|
        eval(File.read(File.join(root, 'config', 'settings.rb')))
      end
    rescue Exception => e
      puts "Failed to initialize settings: #{e.message}\n#{e.backtrace.join("\n")}"
    end

    return @settings
  end

  def self.db_config
    return (@db_config ||= YAML.load_file(File.join(root, 'config', 'database.yml'))[env])
  end

  def self.db_connect
    return false if db_connected?

    begin
      ActiveRecord::Base.establish_connection(Totem.db_config)
    rescue Exception => e
      puts "Failed to establish DB connection: #{e.message}\n#{e.backtrace.join("\n")}"
      return false
    end

    return true
  end

  def self.db_disconnect
    return false unless db_connected?

    ActiveRecord::Base.connection_pool.disconnect!

    return true
  end

  def self.db_reconnect
    db_disconnect
    db_connect

    return true
  end

  def self.db_connected?
    return !!ActiveRecord::Base.connected?
  end

  def self.load_app
    Dir.chdir("#{Totem.root}/app")
    load("loader.rb")
    Dir.chdir(Totem.root)
  end

  def self.component
    return @component || 'default'
  end

  def self.component=(val)
    return @component = val
  end

  def self.instance
    return @instance || 0
  end

  def self.instance=(val)
    return @instance = val
  end

  def self.logger=(val)
    return @logger = val
  end

  def self.logger
    return @logger if @logger

    case env
    when 'development'
      log_to_stdout
    when 'production'
      log_to_file
    else
      log_to_stdout
    end

    return @logger
  end

  def self.log_to_stdout
    init_logger($stdout)

    return nil
  end

  def self.log_to_file
    init_logger(File.join(root, 'log', "#{env}_#{component}_#{instance}.log"))

    return nil
  end

  def self.init_logger(output)
    @logger = Logger.new(output)

    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime} :: #{msg}\n"
    end

    return nil
  end
end
