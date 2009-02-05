require 'xml/libxml'
require 'active_record'
require "#{ File.dirname __FILE__ }/lib/shapes"
require "#{ File.dirname __FILE__ }/lib/shapes/container"
require "#{ File.dirname __FILE__ }/lib/shapes/resource"
require "#{ File.dirname __FILE__ }/lib/shapes/primitive"
require "#{ File.dirname __FILE__ }/lib/acts_as_shape"
require "#{ File.dirname __FILE__ }/lib/xml_serializer"

%w[array boolean datetime enum file float integer string].each do |primitive|
  require "#{ File.dirname __FILE__ }/lib/shapes/primitives/#{ primitive }.rb"
end

# make rmagick dependency optional
require 'RMagick' rescue nil

require "#{ Rails.root }/config/shapes_config"
