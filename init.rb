require 'active_record'
require "#{ File.dirname __FILE__ }/lib/duck_describe"
require "#{ File.dirname __FILE__ }/lib/duck_describe/container"
require "#{ File.dirname __FILE__ }/lib/duck_describe/resource"
require "#{ File.dirname __FILE__ }/lib/duck_describe/primitive"
require "#{ File.dirname __FILE__ }/lib/acts_as_duck"
require "#{ File.dirname __FILE__ }/lib/xml_serializer"

%w[array boolean datetime enum file float integer string].each do |primitive|
  require "#{ File.dirname __FILE__ }/lib/duck_describe/primitives/#{ primitive }.rb"
end

# make rmagick dependency optional
require 'RMagick' rescue nil

require "#{ Rails.root }/config/duck_config"
