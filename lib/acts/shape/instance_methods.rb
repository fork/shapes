module Acts #:nodoc:
  module Shape #:nodoc:
    module InstanceMethods

      # Expires cache for all shapes.
      #
      # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
      def expire_shapes_cache
        shapes.each do |shape| shape.expire_cache end
      end

    end
  end
end
