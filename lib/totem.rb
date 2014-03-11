require 'logger'

require 'totem/version'
require 'totem/tasks/console'
require 'totem/tasks/generator'

module Totem
  def self.initialize(root)
    raise 'Already initialized.' if @setup

    @setup = true
    @root = root

    Bundler.require(Totem.env.to_sym)
    Time.zone = 'UTC'
    load_app

    return true
  end

  def self.root
    return @root
  end

  def self.env
    return (@env ||= (ENV['TOTEM_ENV'] || 'development'))
  end

  def self.load_app
    require "#{Totem.root}/app/loader.rb"
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
