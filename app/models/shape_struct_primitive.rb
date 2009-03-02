class ShapeStructPrimitive < ActiveRecord::Base

  validates_presence_of :ident
  validates_uniqueness_of :ident, :scope => [:shape_struct_id]
  validates_format_of :ident, :with => Shapes::IDENT_MATCH, :message => Shapes::IDENT_MATCH_WARNING
  validate :format_of_primitive

  belongs_to :shape_struct

  after_destroy {|primitive| primitive.alter_resource_in_xml(:remove_resource_from_xml)}
  after_create {|primitive| primitive.alter_resource_in_xml(:add_resource_to_xml)}

  def build_primitive(hash = {})
    Shapes::Builder::Primitive.
      new(hash.merge({:ident => ident , :type => primitive})).
      build_resource
  end

  def alter_resource_in_xml(strategy)
    # do not iterate over the assignments to avoid saving a Shape more than once
    shape_struct.shapes.each do |shape|
      assignments = shape.shape_assignments.
        find(:all, :conditions => {:resource_id => shape_struct.id, :resource_type => 'ShapeStruct'})
      assignments.each do |assignment|
        struct_resource = shape.base.find_by_path assignment.path
        send(strategy, struct_resource)
      end
      shape.save
    end
  end
  def remove_resource_from_xml(struct_resource)
    primitive_resource = struct_resource.children.select{|child| child.ident == ident}.first
    primitive_resource and primitive_resource.destroy
  end
  def check_and_alter_primitive_constraints(struct_resource)
    put struct_resource
  end
  def add_resource_to_xml(struct_resource)
    struct_resource << build_primitive
  end

  def get_constraints
    if constraints && !constraints.blank?
      YAML.load(constraints).
        map{|constraint| constraint = Shapes::Serialization::ConstraintDeserializer.
          new(constraint).
            deserialize[0]
        }
    else
      []
    end
  end
  
  
  def remove_constraint_by_type(constraint_type)
    consts = get_constraints
    consts.delete_if{|c| c.name == constraint_type}
    consts
  end
  
  protected
  
  def format_of_primitive
    Shapes::Primitive.primitives.map(&:to_s).map(&:demodulize).include? primitive or
      errors.add :primitive, 'Wrong primitive format'
  end
end
