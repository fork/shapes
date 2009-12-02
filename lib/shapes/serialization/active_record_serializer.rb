module Shapes
  module Serialization
    class ActiveRecordSerializer < ActiveRecord::Serialization::Serializer

      def build_xml
        xml_builder.send(node_name, node_attributes) { |xml|
          (serializable_attributes + serializable_method_attributes).each do |attribute|
            attribute.build_xml
          end
          procs = options.delete(:procs)
          add_includes { |association, records, opts| add_associations(association, records, opts) }
          options[:procs] = procs
          add_procs
        }
      end

      protected

      def xml_builder
        @xml_builder ||= options.delete(:xml_builder)
      end

      def add_associations(association, records, opts)
        if records.is_a?(Enumerable)
          tag = association.to_s.dasherize
          if records.empty?
            xml_builder.array({ 'resource-type' => 'Primitive', :ident => tag })
          else
            xml_builder.array({ 'resource-type' => 'Primitive', :ident => tag }) do |xml|
              association_name = association.to_s.singularize
              records.each do |record|
                record.build_xml(xml_builder)
              end
            end
          end
        else
          if record = @record.send(association)
            record.build_xml(xml_builder)
          end
        end
      end

      def node_attributes
        attributes = {
          'resource-type' => "ActiveRecord",
          'record-id' => @record.id,
          :ident => options[:ident]
        }
        options[:description].blank? ? attributes : attributes.merge({ :description => options[:description] })
      end

      def node_name
        @record.class.to_s.underscore.dasherize
      end

      def serializable_attributes
        serializable_attribute_names.collect { |name| Attribute.new(name, @record, xml_builder) }
      end

      def serializable_method_attributes
        Array(options[:methods]).inject([]) do |method_attributes, name|
          method_attributes << MethodAttribute.new(name.to_s, @record, xml_builder) if @record.respond_to?(name.to_s)
          method_attributes
        end
      end

      def add_procs
        if procs = options.delete(:procs)
          [ *procs ].each do |proc|
            proc.call(options)
          end
        end
      end

      def reformat_name(name)
        name = name.camelize if camelize?
        dasherize? ? name.dasherize : name
      end

      class Attribute #:nodoc:
        attr_reader :name, :value, :type, :options

        def initialize(name, record, xml_builder)
          @name, @record, @xml_builder = name, record, xml_builder

          @type  = compute_type
          @value = compute_value
          @options = options
          
        end

        def build_xml
          primitive = Shapes::Builder::Primitive.new(attribute_hash).build_resource
          primitive.xml_builder = @xml_builder
          primitive.build_xml 
        end
      
        def attribute_hash
          { :value => @value, :ident => @name, :type => type.to_s.camelize }
        end

        protected

        def compute_type
          type = @record.class.columns_hash[name].type

          case type
            when :text
              :string
            when :time
              :datetime
            else
              type
          end
        end

        def compute_value
          value = @record.send(name)

          if formatter = Hash::XML_FORMATTING[type.to_s]
            value ? formatter.call(value) : nil
          else
            value
          end
        end
      end

      class MethodAttribute < Attribute #:nodoc:

        protected

        def compute_type
          Hash::XML_TYPE_NAMES[@record.send(name).class.name] || :string
        end
      end
    end
  end
end
