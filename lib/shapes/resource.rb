module Shapes
  class Resource

    attr_accessor :ident, :description, :xml_node, :parent, :resource_type, :errors, :xml_builder
    attr_reader :path, :from_xml, :build_node_content, :children, :options, :dirty, :preview, :after_save, :after_clone

    include Shapes::Constraints

    def initialize(*args)
      @children, @errors, @new_resource = [], [], true
      @options = args.extract_options!
      super #Constraint module
    end

    def children
      @children ||= []
    end

    # builds a path based on idents up to base resource, separated by #
    # accepts optional ident
    # Author: hm@fork.de
    def path(old = false)
      # FIXME: Do this without exception!
      #"#{ @parent.path unless @parent == self }##{ ident }"
      # rescue base path
      "#{@parent.path(old) rescue ''}##{ old ? @_ident : @ident}"
    end

    # accepts a string ("#foo#bar#foobar") and tries to find the appropriate resource in the branch
    # Author: hm@fork.de
    def find_by_path(resource_path)
      idents = resource_path.split(/#/).delete_if {|x| x.blank? }
      return unless ident.eql?(idents.shift)
      return self if idents.empty?
      child = children.select{|r| r.ident == idents.first}.first
      child and child.find_by_path(idents * '#')
    end

    #flag resource and all parents up to base as dirty
    def conterminate_path
      @dirty = true and @parent and @parent.conterminate_path
    end

    def build_xml
      xml_builder.send(xml_node_name, node_attributes) { |xml|
        build_node_content
      }
      xml_builder
    end

    def xml_builder(&block)
      @xml_builder ||= ::Nokogiri::XML::Builder.new(&block)
    end

    def node_attributes
      attributes = super.merge 'ident' => ident
      description.blank? ? attributes : attributes.merge({ 'description' => description })
    end

    def base
      @parent.base
    end

    def base?; false; end

    def depth
      @depth ||= parent.depth + 1
    end

    # write xml to filesystem
    # Author: hm@fork.de
    def cache_xml
      write_xml = build_xml.to_xml
      file = File.new "#{cache_file_path}.xml", 'w'
      file.puts write_xml
      file.close
      write_xml
    end

    # deletes the assignment from the parent object
    # Author: hm@fork.de
    def destroy
      #primitives in structs are without parent
      parent and parent.children.delete self
    end

    #don't update ident and description for structs or records
    def update_attributes(params)
      conterminate_path
      @ident = params[:ident].to_s
      @description = params[:description].to_s
    end

    def read_from_node
      # save ident twice to reset ident in case of a collation. Ident is a special case here because it is part of the resource ID.
      @ident        = @_ident = @xml_node['ident']
      @description  = @xml_node['description']
      @resource_type  = @xml_node['resource-type']
      @new_resource = false
      super #Constraint module
    end

    def new_resource?
      @new_resource
    end

    #is true if the parent resource is a struct
    def struct_resource?
      parent.is_a? Shapes::Struct
    end

    def dasherized_name
      underscored_name.dasherize
    end
    alias_method :xml_node_name, :dasherized_name

    def underscored_name
      name.underscore
    end

    def name
      self.class.name.demodulize
    end

    protected

    def validate
      if @dirty || @new_resource
        validate_ident
        validate_ident_uniqueness
      end
      super #Constraint module
    end

    def validate_ident
      @errors << Shapes::Error.new(Shapes::IDENT_MATCH_WARNING, path) unless ident.match(Shapes::IDENT_MATCH)
    end

    def validate_ident_uniqueness
      if parent && parent.children.collect{ |child| child.ident if child != self }.include?(@ident)
        @errors << Shapes::Error.new(Shapes::IDENT_UNIQUENESS_WARNING, path) and (@ident = @_ident)
      end
    end

    def cache_file_path
      path_to_file = File.join Shapes.cache_dir_path, *path.split('#').delete_if {|x| x.blank?}
      FileUtils.makedirs File.dirname(path_to_file)
      path_to_file
    end

  end
end
