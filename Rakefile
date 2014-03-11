require 'bundler/gem_tasks'

desc 'Start a Totem interactive console'
task :console do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require 'totem'

  Totem::Shell.new([:console]).run
end
