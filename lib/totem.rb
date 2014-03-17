require 'logger'

require 'totem/version'
require 'totem/shell'
require 'totem/shell_cmds/base'
require 'totem/shell_cmds/console'
require 'totem/shell_cmds/new'

module Totem
  def self.initialize(root)
    raise 'Already initialized.' if @setup

    # Must stay at top of method.
    run_callbacks(:before_init)

    @setup = true
    @root = root
    Bundler.require(Totem.env.to_sym)
    run_callbacks(:before_first_load_app)
    $LOAD_PATH.unshift(root + '/app')
    load_app
    run_callbacks(:after_first_load_app)

    # Must stay at bottom of method.
    run_callbacks(:after_init)

    return true
  end

  def self.root
    return @root
  end

  def self.env
    return (@env ||= (ENV['TOTEM_ENV'] || 'development'))
  end

  def self.env=(val)
    run_callbacks(:before_set_env)
    raise 'env may only be set once and must be set before calling logger' if @logger || @env
    @env = val
    run_callbacks(:after_set_env)
  end

  def self.component
    return @component ||= ENV['TOTEM_COMPONENT']
  end

  def self.component=(val)
    run_callbacks(:before_set_component)
    raise 'component may only be set once and must be set before calling logger' if @logger || @component
    @component = val
    run_callbacks(:after_set_component)
  end

  def self.instance
    return @instance || ENV['TOTEM_INSTANCE']
  end

  def self.instance=(val)
    run_callbacks(:before_set_instance)
    raise 'instance may only be set once and must be set before calling logger' if @logger || @instance
    @instance = val
    run_callbacks(:after_set_instance)
  end

  def self.logger
    return @logger || log_to_file
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

  def self.reload
    run_callback(:before_reload)
    load_app
    run_callback(:after_reload)
  end

  def self.restart
    run_callbacks(:before_restart)
    load_app
    run_callbacks(:after_restart)
  end

  private

  def self.load_app
    run_callbacks(:before_load_app)
    load "#{Totem.root}/app/loader.rb"
    run_callbacks(:after_load_app)

    return nil
  end

  def self.log_to_stdout
    return init_logger($stdout)
  end

  def self.log_to_file
    return init_logger(log_file_path)
  end

  def self.init_logger(output)
    raise 'Logger is already initialized' if @logger

    @logger = Logger.new(output)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime} :: #{msg}\n"
    end

    return @logger
  end

  def self.run_callbacks(type)
    @callbacks ||= {}
    (@callbacks[type] || []).each { |cb| cb.call }

    return nil
  end
end
