module Shapes
  class Resource

    attr_accessor :ident, :description, :xml_node, :xml_builder, :parent, :resource_type, :errors
    attr_reader :presenter, :path, :from_xml, :add_node_content, :children, :options

    include Shapes::Constraints

    def initialize(*args)
      @children, @errors, @new_resource = [], [], true
      @options = args.extract_options!
      super #Constraint module
    end

    def children
      @children ||= []
    end

    # builds a path based on the idents up to the base resource, separated by #
    # Author: hm@fork.de
    def path
      # FIXME: Do this without exception!
      #"#{ @parent.path unless @parent == self }##{ ident }"
      # rescue base path
      "#{@parent.path rescue ''}##{ident}"
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

    # generates a new XML Builder for the specific resource
    # Author: hm@fork.de
    def xml_builder
      @xml_builder ||= begin
        @options[:indent] ||= 2
        builder = @options[:builder] ||= ::Builder::XmlMarkup.new(:indent => 2)

        unless @options[:skip_instruct]
          builder.instruct!
          @options[:skip_instruct] = true
        end

        builder
      end
    end

    def to_xml
      xml_builder.tag!(xml_node_name, node_attributes) do
        add_node_content
      end
    end

    def node_attributes
      super.merge 'ident' => ident, 'description' => description
    end

    def base
      @parent.base
    end

    # write xml to filesystem
    # Author: hm@fork.de
    def cache_xml
      write_xml = to_xml
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
      @ident = params[:ident].to_s
      @description = params[:description].to_s
    end

    def read_from_node
      @ident        = @xml_node['ident']
      @description  = @xml_node['description']
      @resource_type  = @xml_node['resource-type']
      @new_resource = false
      super #Constraint module
    end

    def new_resource?
      @new_resource
    end

    # installs presenter for self and all children
    # Author: hm@fork.de
    def install_presenter(controller)
      @presenter = "Shapes::Presenter::#{self.class.name.demodulize}".constantize.new self, controller
      children.collect{|children|
          children.install_presenter controller
      }
    end

    def dasherized_name
      underscored_name.dasherize
    end
    alias_method :xml_node_name, :dasherized_name

    protected
    def validate
      validate_ident
      validate_ident_uniqueness
      super #Constraint module
    end
    def validate_ident
      @errors << Shapes::Error.new({:path => path, :message => Shapes::IDENT_MATCH_WARNING}) unless ident.match(Shapes::IDENT_MATCH)
    end

    def validate_ident_uniqueness
      @errors << Shapes::Error.new({:path => path, :message => Shapes::IDENT_UNIQUENESS_WARNING}) if parent &&
        parent.children.collect{|child| child.ident if child != self}.include?(ident)
    end

    def underscored_name
      self.class.name.demodulize.underscore
    end

    def cache_file_path
      path_to_file = File.join Shapes.cache_dir_path, *path.split('#').delete_if {|x| x.blank?}
      FileUtils.makedirs File.dirname(path_to_file)
      path_to_file
    end

  end
end
