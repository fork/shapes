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

    # overwrites the base method of Shapes::Resource that would call the base method of the parent resource
    # Author: hm@fork.de
    def base
      self
    end

    # Author: hm@fork.de
    def shape
      @shape ||= Shape.find_by_id shape_id
    end

    # builds the objecttree defined by the resource xml node
    # Author: hm@fork.de
    def from_xml
      @children = xml_doc.find('//base/*').collect{|child_node|
        build_child_from_xml child_node
      }
    end

    def build_xml
      start = Time.now
      @xml_builder = ::Nokogiri::XML::Builder.new do |xml|
		    xml.base(node_attributes) {
		      build_node_content xml
		    }
      end
      @xml_builder.to_xml
      p "time time time #{Time.now - start}"
      @xml_builder
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
