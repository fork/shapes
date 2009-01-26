class DuckStruct < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  validate :no_primitive
  before_validation :camelize_name

  has_many :duck_struct_primitives,
    :dependent => :destroy

  has_many :duck_assignments,
    :as => :resource,
    :dependent => :destroy
  has_many :ducks,
    :through => :duck_assignments

  named_scope :global, :conditions => {:duck_id => nil}

  belongs_to :duck

  alias_method :primitives, :duck_struct_primitives

  def global
    find_by_duck_id nil
  end

  def struct_class
    method_array = duck_struct_primitives.collect do |duck_struct_primitive|
      duck_struct_primitive.ident.to_sym
    end
    DuckDescribe::Struct.struct_class self.name, method_array
  end

  protected

  def camelize_name
    self.name = self.name.camelize
  end

  def no_primitive
    if DuckDescribe::Primitive.primitives.collect{|primitive| primitive.name.demodulize}.
      include?(self.name)
        self.errors.add :name, 'Cannot use name of primitive'
    end
  end
end
