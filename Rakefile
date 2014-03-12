require 'bundler/gem_tasks'

desc 'Start an IRB session'
task :console do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require 'totem'

  ARGV.clear
  IRB.start
end
