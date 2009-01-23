module DuckDescribe
  class Resource

    attr_accessor :ident, :description, :xml_node, :xml_builder, :parent
    attr_reader :presenter, :path, :from_xml, :add_node_content, :errors, :children, :options

    def initialize(*args)
      @children, @errors, @new_resource = [], [], true
      @options = args.extract_options!
    end

    def children
      @children ||= []
      # FIXME: Do this without exception!
      #"#{ @parent.path unless @parent == self }##{ ident }"
    end

    def path
      # FIXME: Do this without exception!
      #"#{ @parent.path unless @parent == self }##{ ident }"
      # rescue base path
      "#{@parent.path rescue ''}##{ident}"
    end

    def find_by_path(resource_path)
      idents = resource_path.split(/#/).delete_if {|x| x.blank? }
      return unless ident.eql?(idents.shift)
      return self if idents.empty?
      child = children.select{|r| r.ident == idents.first}.first
      child and child.find_by_path(idents * '#')
    end

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
      {'ident' => ident, 'description' => description}
    end

    def base
      @parent.base
    end

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
      @new_resource = false
    end

    def new_resource?
      @new_resource
     end

    def install_presenter(controller)
      @presenter = "DuckDescribe::Presenter::#{self.class.name.demodulize}".constantize.new self, controller
      children.collect{|children|
          children.install_presenter controller
      }
    end

    protected
    def validate
      validate_ident
      validate_ident_uniqueness
    end
    def validate_ident
      @errors << DuckDescribe::Error.new({:path => path, :message => DuckDescribe::IDENT_MATCH_WARNING}) unless ident.match(DuckDescribe::IDENT_MATCH)
    end

    def underscored_name
      self.class.name.demodulize.underscore
    end

    def dasherized_name
      underscored_name.dasherize
    end
    alias_method :xml_node_name, :dasherized_name

    def validate_ident_uniqueness
      errors << DuckDescribe::Error.new({:path => path, :message => DuckDescribe::IDENT_UNIQUENESS_WARNING}) if parent &&
        parent.children.collect{|child| child.ident if child != self}.include?(ident)
    end
  end
end
