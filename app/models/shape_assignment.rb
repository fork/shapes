class ShapeAssignment < ActiveRecord::Base

  belongs_to :shape
  belongs_to :resource, 
    :polymorphic => true

  after_destroy :remove_resource_from_xml
  validates_uniqueness_of :shape_id, :scope => [:path, :resource_id]

  def remove_resource_from_xml
    resource = shape.base.find_by_path path
    resource and resource.destroy and shape.save
  end

end
