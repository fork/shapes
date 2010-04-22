class Shape < ActiveRecord::Base

  has_many :local_structs, 
    :class_name => 'ShapeStruct',
    :dependent => :destroy

  def global_shape_structs
    ShapeStruct.global
  end

  has_many :shape_assignments,
    :dependent => :delete_all
  has_many :resources,
    :through => :shape_assignments,
    :source => :resource

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => Shapes::IDENT_MATCH, :message => Shapes::IDENT_MATCH_WARNING

  validate :validate_shape

  before_update { |shape| shape.xml = shape.base.build_xml.to_xml }
  after_create { |shape| shape.xml = shape.base.build_xml.to_xml }

  after_save { |shape| shape.base.after_save }
  after_update :expire_cache
  after_destroy :expire_cache, :destroy_resources

  composed_of :base,
    :class_name => 'Shapes::Base',
    :mapping => [ %w(xml xml), %w(name ident), %w(id shape_id) ]

  # expire cache also for dirty objects
  def expire_cache
    filename = name_changed? ? name_was : name
    FileUtils.rm_rf(File.join(Shapes.cache_dir_path, filename))
    FileUtils.rm_f(File.join(Shapes.cache_dir_path, "#{filename}.xml"))
  end

  def cache_xml
    base.cache_xml
  end

  protected
  # FIXME: Resource.validate should accept a parameter (the instance error object) and write directly to it.
  def validate_shape
    base.validate
    base.errors.collect{|error|
      errors.add_to_base(error.show_message)
    }
  end

  def destroy_resources
    base.destroy
  end

end
