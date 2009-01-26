module Shapes
  class Base < Shapes::Resource

    include Shapes::Container

    attr_reader :xml, :ident, :shape_id, :shape

    def initialize(xml, ident, shape_id)
      super
      @xml, @ident, @shape_id = xml, ident, shape_id
      @collected_errors = []
      from_xml
    end

    def base
      self
    end

    def shape
      @shape ||= Shape.find_by_id shape_id
    end

    def from_xml
      @children = xml_doc.find('//base/*').collect{|child_node|
        build_child_from_xml child_node
      }
    end

    def to_xml
      args = ['base', node_attributes ]
      xml_builder.tag!(*args) do
        add_node_content
      end
    end

    protected
    # Returns stored XML document or generates a new one on-the-fly
    def xml_doc
       @xml_doc ||= unless @xml.blank?
        ::XML::Parser.string(@xml).parse
      else
        doc       = ::XML::Document.new
        doc.root  = ::XML::Node.new 'base'
        doc
      end
    rescue
      raise RuntimeError, 'expected document to parse'
    end

  end
end
