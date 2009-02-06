require 'active_record'
require "#{ File.dirname __FILE__ }/lib/shapes"
require "#{ File.dirname __FILE__ }/lib/shapes/container"
require "#{ File.dirname __FILE__ }/lib/shapes/resource"
require "#{ File.dirname __FILE__ }/lib/shapes/primitive"
%w[array boolean datetime enum file float integer string].each do |primitive|
  require "#{ File.dirname __FILE__ }/lib/shapes/primitives/#{ primitive }.rb"
end

module Shapes::Extension
  # Allow lazy loading of models while preserving configured models.
  #
  # Super must be called before Shapes.extend_model is invoked, otherwise
  # super overwrites inherited attributes.
  #
  # Author: Florian Aßmann (flazy@fork.de) [2009-02-06]
  def inherited(base)
    result = super
    Shapes.extend_model base
    result
  end
end
ActiveRecord::Base.extend Shapes::Extension

# make rmagick dependency optional
require 'RMagick' rescue nil

require 'xml/libxml'
require "#{ File.dirname __FILE__ }/lib/xml_serializer"

require "#{ Rails.root }/config/shapes_config"
