module Shapes

  IDENT_MATCH = /^[a-zA-Z0-9_-]+$/
  IDENT_MATCH_WARNING = 'Ident must be lowercase and must not contain special characters or spaces.'
  IDENT_UNIQUENESS_WARNING = 'Ident must be unique.'

  # TODO: Should be configurable.
  FILE_DIR = File.join Rails.public_path, 'shapes', 'files'
  FILE_TMP_DIR = File.join RAILS_ROOT, 'tmp', 'shapes'

  SELECT_OPTION_STRUCT = Struct.new(:name, :id)
  SELECT_OPTION_GROUP_STRUCT = Struct.new(:name, :options)

  CACHE_PATH = File.join Rails.public_path, 'shapes', 'xml'

  # Default options for acts_as_shape.
  DEFAULT_OPTS = {
    :to_shape_xml_options => nil,
    :scope                => {},
    :select_name          => :id
  }

  @config = {}
  def self.config
    @config
  end
  # Stores configuration of class with given <tt>class_name</tt> for later
  # use (see Shapes.extend_model).
  #
  # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
  def self.acts_as_shape(class_name, opts = {})
    @config[class_name] = DEFAULT_OPTS.merge opts
  end

  # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
  def self.install_associations(base)
    base.has_many :shape_assignments, :dependent => :destroy
    base.has_many :shapes, :through => :shape_assignments
  end
  # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
  def self.install_hooks(base)
    base.after_update :expire_shapes_cache
    base.after_destroy :expire_shapes_cache
  end
  # Author: Florian Aßmann (flazy@fork.de) [2009-02-06]
  def self.install_method(base, method_name, method)
    case method
    when String, Symbol
      base.class_eval %Q"def #{ method_name }; #{ method } end"
    when Proc
      base.class_eval { define_method method_name, &method }
    else
      raise ArgumentError, 'expected String, Symbol or Proc'
    end
  end
  # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
  def self.install_options(base, options)
    base.write_inheritable_attribute :acts_as_shape_options, options
    base.class_inheritable_reader :acts_as_shape_options
  end
  # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
  def self.install_scope(base, scope)
    base.named_scope :shape_scope, scope
  end

  # Author: Florian Aßmann (flazy@fork.de) [2009-02-06]
  def self.extend_model(base) #:nodoc:
    if options = @config[base.name]
      install_options base, options
      install_associations base
      install_method base, :shape_name, options[:select_name]
      install_method base, :expire_shapes_cache, 'shapes.each do |shape| shape.expire_cache end'
      install_hooks base
      install_scope base, options[:scope]
    end
  end

  def self.cache_dir_path
    FileUtils.makedirs Shapes::CACHE_PATH
    Shapes::CACHE_PATH
  end

end
