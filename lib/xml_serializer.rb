module ActiveRecord
  module Serialization

    def to_duck_xml(options = {}, &block)
      options = options.merge(acts_as_duck_options) if self.class.method_defined?(:acts_as_duck_options)
      serializer = DuckXmlSerializer.new(self, options)
      block_given? ? serializer.to_s(&block) : serializer.to_s
    end

  end

  class DuckXmlSerializer < ActiveRecord::Serialization::Serializer

    def builder
      @builder ||= begin
        options[:indent] ||= 2
        builder = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
        builder
      end
    end

    def serialize
      args = [@record.class.to_s.underscore.dasherize, 
        {'resource-type' => "ActiveRecord", 
        'record-id' => @record.id, 
        :ident => options[:ident], 
        :description => options[:description]}]

      builder.tag!(*args) do
        add_attributes
        procs = options.delete(:procs)
        add_includes { |association, records, opts| add_associations(association, records, opts) }
        options[:procs] = procs
        add_procs
        yield builder if block_given?
      end
    end

    def add_attributes
      (serializable_attributes + serializable_method_attributes).each do |attribute|
        attribute.add_primitive
      end
    end

    # To replicate the behavior in ActiveRecord#attributes,
    # :except takes precedence over :only.  If :only is not set
    # for a N level model but is set for the N+1 level models,
    # then because :except is set to a default value, the second
    # level model can have both :except and :only set.  So if
    # :only is set, always delete :except.
    def serializable_attributes
      serializable_attribute_names.collect { |name| Attribute.new(name, @record, {:xml_builder => builder}) }
    end

    def serializable_method_attributes
      Array(options[:methods]).inject([]) do |method_attributes, name|
        method_attributes << MethodAttribute.new(name.to_s, @record, {:xml_builder => builder}) if @record.respond_to?(name.to_s)
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

    def add_associations(association, records, opts)
      if records.is_a?(Enumerable)
        tag = association.to_s
        tag = tag.dasherize
        if records.empty?
          builder.tag!('array', 'resource-type' => 'Primitive', :ident => tag)
        else
          builder.tag!('array', 'resource-type' => 'Primitive', :ident => tag) do
            association_name = association.to_s.singularize
            records.each do |record|
              record.to_duck_xml opts
            end
          end
        end
      else
        if record = @record.send(association)
          record.to_duck_xml
        end
      end
    end

    def reformat_name(name)
      name = name.camelize if camelize?
      dasherize? ? name.dasherize : name
    end

    class Attribute #:nodoc:
      attr_reader :name, :value, :type, :options

      def initialize(name, record, options = {})
        @name, @record = name, record

        @type  = compute_type
        @value = compute_value
        @options = options
      end

      def add_primitive
        primitive = DuckDescribe::Builder::Primitive.
          new(attribute_hash).build_resource
        primitive.xml_builder = options[:xml_builder]
        primitive.to_xml
      end

      def attribute_hash
        {:value => @value, :ident => @name, :type => type.to_s.camelize}
      end

      protected
      
      def compute_type
        type = @record.class.serialized_attributes.has_key?(name) ? :yaml : @record.class.columns_hash[name].type

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
