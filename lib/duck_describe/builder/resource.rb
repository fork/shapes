module DuckDescribe
  module Builder
    class Resource
        attr_reader :resource
        def initialize(options = {})
          @resource.ident = options[:ident]
          @resource.description = options[:description]
        end
    end
  end
end
