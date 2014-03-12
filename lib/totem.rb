require 'logger'

require 'totem/version'
require 'totem/shell'
require 'totem/shell_cmds/base'
require 'totem/shell_cmds/console'
require 'totem/shell_cmds/new'

module Totem
  def self.initialize(root)
    raise 'Already initialized.' if @setup

    @setup = true
    @root = root
    Bundler.require(Totem.env.to_sym)
    $LOAD_PATH.unshift(root + '/app')))
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
    return @component ||= ENV['TOTEM_COMPONENT']
  end

  def self.instance
    return @instance || ENV['TOTEM_INSTANCE']
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

  def self.log_file_path
    name = env
    name << "_#{component}" if component
    name << "_#{instance}" if instance
    name << '.log'

    return File.join(root, 'log', name)
  end

  def self.log_to_file
    init_logger(File.join(root, 'log', "#{env}_#{component}_#{instance}.log"))

    return nil
  end

  def self.init_logger(output)
    raise 'Logger is already initialized' if @logger

    @logger = Logger.new(output)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime} :: #{msg}\n"
    end

    return nil
  end
end
