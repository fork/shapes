require 'fileutils'

module Install

  def copy(basename, target)
    source = File.join File.dirname __FILE__, 'install', basename
    target = File.join Rails.root, target

    begin
      FileUtils.cp source, target, :verbose => true
    rescue
      puts "=> failed!"
    end
  end

end

puts 'DuckDescribe:'
puts

Install.copy 'config.rb', %w[config duck_config.rb]
