class DuckStructPrimitive < ActiveRecord::Base

  validates_presence_of :ident
  validates_uniqueness_of :ident, :scope => [:duck_struct_id]
  validates_format_of :ident, :with => DuckDescribe::IDENT_MATCH, :message => DuckDescribe::IDENT_MATCH_WARNING
  validate :format_of_primitive

  belongs_to :duck_struct

  def build_primitive(hash = {})
    DuckDescribe::Builder::Primitive.
      new(hash.merge({:ident => ident , :type => primitive})).
      build_resource
  end

  protected

  def format_of_primitive
    DuckDescribe::Primitive.primitives.map(&:to_s).map(&:demodulize).include? primitive or
      errors.add :primitive, 'Wrong primitive format'
  end
end
