class ShapeStructPrimitive < ActiveRecord::Base

  validates_presence_of :ident
  validates_uniqueness_of :ident, :scope => [:shape_struct_id]
  validates_format_of :ident, :with => Shapes::IDENT_MATCH, :message => Shapes::IDENT_MATCH_WARNING
  validate :format_of_primitive

  belongs_to :shape_struct

  def build_primitive(hash = {})
    Shapes::Builder::Primitive.
      new(hash.merge({:ident => ident , :type => primitive})).
      build_resource
  end

  protected

  def format_of_primitive
    Shapes::Primitive.primitives.map(&:to_s).map(&:demodulize).include? primitive or
      errors.add :primitive, 'Wrong primitive format'
  end
end
