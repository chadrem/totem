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
    run_callbacks(:before_load_app)
    $LOAD_PATH.unshift(root + '/app')
    load_app
    run_callbacks(:after_load_app)

    return true
  end

  def self.root
    return @root
  end

  def self.env
    return (@env ||= (ENV['TOTEM_ENV'] || 'development'))
  end

  def self.env=(val)
    raise 'env may only be set once and must be set before calling logger' if @logger || @env
    @env = val
  end

  def self.load_app
    require "#{Totem.root}/app/loader.rb"
  end

  def self.component
    return @component ||= ENV['TOTEM_COMPONENT']
  end

  def self.component=(val)
    raise 'component may only be set once and must be set before calling logger' if @logger || @component
    @component = val
  end

  def self.instance
    return @instance || ENV['TOTEM_INSTANCE']
  end

  def self.instance=(val)
    raise 'instance may only be set once and must be set before calling logger' if @logger || @instance
    @instance = val
  end

  def self.logger=(val)
    return @logger = val
  end

  def self.logger
    return @logger if @logger

    log_to_file

    return @logger
  end

  def self.register_callback(type, callback=nil, &block)
    @callbacks ||= {}
    (@callbacks[type] ||= []) << (callback || block)

    return true
  end

  def self.process_name
    name = "#{env}"
    name << "_#{component}" if component && component.length > 0
    name << "_#{instance}" if instance && instance.length > 0

    return name
  end

  def self.log_file_path
    return File.join(root, 'log', "#{process_name}.log")
  end

  private

  def self.log_to_stdout
    init_logger($stdout)

    return nil
  end

  def self.log_to_file
    init_logger(log_file_path)

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

  def self.run_callbacks(type)
    @callbacks ||= {}
    (@callbacks[type] || []).each { |cb| cb.call }

    return nil
  end
end
