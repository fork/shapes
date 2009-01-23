module DuckDescribe
  class Base < DuckDescribe::Resource

    include DuckDescribe::Container
      
    attr_reader :xml, :ident, :duck_id, :duck

    def initialize(xml, ident, duck_id)
      super
      @xml, @ident, @duck_id = xml, ident, duck_id
      @collected_errors = []
      from_xml
    end

    def base
      self
    end

    def duck
      @duck ||= Duck.find_by_id duck_id
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
