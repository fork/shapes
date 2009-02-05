require 'fileutils'

puts 'Install config:'
puts

ROOT = File.dirname __FILE__  
rails_root = File.join ROOT, %w[ .. .. .. ]
RAILS_ROOT = File.expand_path rails_root
  
source = File.join ROOT, 'install', 'config.rb'
target = File.join RAILS_ROOT, %w[config shapes_config.rb]

FileUtils.cp source, target, :verbose => true

puts 'Run script/generate plugin_migration to generate the migration.'
puts 'Run rake db:migrate to migrate.'
