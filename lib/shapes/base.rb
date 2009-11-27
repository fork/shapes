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
      @children = xml_doc.xpath('//base/*').collect{ |child_node|
        build_child_from_xml child_node
      }
    end

    def conterminate_path
      @dirty = true
    end

    def build_xml
      ::Nokogiri::XML::Builder.new do |xml|
		    xml.base(node_attributes) {
		      @xml_builder= xml
		      build_node_content
		    }
      end
    end

    protected
    # Returns stored XML document or generates a new one on-the-fly
    def xml_doc
       @xml_doc ||= unless @xml.blank?
        Nokogiri.parse(@xml)
      else
        Nokogiri::XML::Document.new
      end
    rescue
      raise RuntimeError, 'expected document to parse'
    end

  end
end
