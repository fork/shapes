require 'xml/libxml'
require 'active_record'
require "#{ File.dirname __FILE__ }/lib/acts/shape/instance_methods"
require "#{ File.dirname __FILE__ }/lib/shapes"
require "#{ File.dirname __FILE__ }/lib/shapes/container"
require "#{ File.dirname __FILE__ }/lib/shapes/resource"
require "#{ File.dirname __FILE__ }/lib/shapes/primitive"
require "#{ File.dirname __FILE__ }/lib/xml_serializer"

%w[array boolean datetime enum file float integer string].each do |primitive|
  require "#{ File.dirname __FILE__ }/lib/shapes/primitives/#{ primitive }.rb"
end

# make rmagick dependency optional
require 'RMagick' rescue nil

module ActiveRecord #:nodoc:
  class Base #:nodoc:
    def self.inherited_with_shapes(base)
      inherited_without_shapes(base)
      Shapes.extend_model(base)
    end
    class << self
      alias_method_chain :inherited, :shapes
    end
  end
end

require "#{ Rails.root }/config/shapes_config"
