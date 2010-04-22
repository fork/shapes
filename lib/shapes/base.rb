module Shapes
  class Base < Shapes::Resource

    include Shapes::Container

    attr_reader :xml, :ident, :shape_id, :shape, :xml_doc
    attr_accessor :apply_assignments

    def initialize(xml, ident, shape_id)
      super
      @xml, @ident, @shape_id = xml, ident, shape_id
      @collected_errors = []
      from_xml
    end

    # overwrites the base method of Shapes::Resource that would call the base method of the parent resource
    # Author: hm@fork.de
    def base; self; end
    
    def base?; true; end

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

    def depth; 0; end

    def conterminate_path; @dirty = true; end

    def build_xml
      xml_builder do |xml|
		    xml.base(node_attributes) {
		      @xml_builder = xml
		      build_node_content
		    }
      end
    end

    #all resources are clonable except ActiveRecords and local Structs
    #file values an the corresponding files won't get cloned
    def purged_xml_for_clone
      local_structs_regex = []
      shape.local_structs.each do | struct |
        local_structs_regex << struct.name.underscore.downcase.dasherize
      end
      xml_doc.search('*[@resource-type="ActiveRecord"]', *local_structs_regex.uniq).unlink
      xml_doc.search('file[@resource-type="Primitive"]').each do |file|
        file['value'] = ''
        file['width'] = ''
        file['height'] = ''
        file['content_type'] = ''
      end
      xml_doc
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
