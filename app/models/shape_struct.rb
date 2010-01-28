class ShapeStruct < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  validate :no_primitive
  before_validation :camelize_name

  has_many :shape_struct_primitives,
    :dependent => :destroy

  has_many :shape_assignments,
    :as => :resource,
    :dependent => :destroy do
    def find_first_by_path_and_shape(path, shape)
      find :first, 
        :conditions => { :path => path, :shape_id => shape }
    end
  end

  has_many :shapes,
    :through => :shape_assignments

  named_scope :global, :conditions => {:shape_id => nil}

  belongs_to :shape

  alias_method :primitives, :shape_struct_primitives

  def global
    find_by_shape_id nil
  end


  def struct_class
    method_array = shape_struct_primitives.collect do |shape_struct_primitive|
      shape_struct_primitive.ident.to_sym
    end
    Shapes::Struct.struct_class self.name, method_array
  end

  protected

  def camelize_name
    self.name = self.name.camelize
  end

  def no_primitive
    if Shapes::Primitive.primitives.collect{|primitive| primitive.name.demodulize}.
      include?(self.name)
        self.errors.add :name, 'Cannot use name of primitive'
    end
  end
end
