class Duck < ActiveRecord::Base

  has_many :local_duck_structs, :class_name => 'DuckStruct',
    :dependent => :destroy

  def global_duck_structs
    DuckStruct.global
  end

  has_many :duck_struct_assignments,
    :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => DuckDescribe::IDENT_MATCH, :message => DuckDescribe::IDENT_MATCH_WARNING

  validate :validate_duck

  before_update {|duck| duck.xml = duck.base.to_xml}
  after_create {|duck| duck.xml = duck.base.to_xml}

  after_create :cache_xml
  after_update :expire_cache, :cache_xml
  after_destroy :expire_cache, :destroy_resources
    
  has_many :duck_appearances,
    :dependent => :destroy

  composed_of :base,
    :class_name => 'DuckDescribe::Base',
    :mapping => [ %w(xml xml), %w(name ident), %w(id duck_id) ]

  # write xml to filesystem
  def cache_xml
    file = File.new cache_file_path, 'w'
    file.puts xml
    file.close
  end

  # expire cache also for dirty objects
  def expire_cache
    filename = name_changed? ? name_was : name
    FileUtils.rm_f(File.join(cache_dir_path, "#{filename}.xml"))
  end
  
  def self.find_and_install_presenter(name, controller, conditions = {})
    duck = find_or_initialize_by_name(:name => name, *conditions)
    duck.base.install_presenter controller
    duck
  end

  def show(path, options = {}, &block)
    if resource = base.find_by_path(path)
      resource.presenter.to_html options, &block
    else
      path
    end
  end

  protected
  # FIXME: Resource.validate should accept a parameter (the instance error object) and write directly to it.
  def validate_duck
    base.validate
    base.errors.collect{|error|
      errors.add_to_base(error.show_message)
    }
  end

  def cache_dir_path
    FileUtils.makedirs DuckDescribe::CACHE_PATH
    DuckDescribe::CACHE_PATH
  end
  
  def cache_file_path
    File.join cache_dir_path, "#{name}.xml"
  end

  def destroy_resources
    base.destroy
  end
end
