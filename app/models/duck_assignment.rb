class DuckAssignment < ActiveRecord::Base

  belongs_to :duck
  belongs_to :resource, 
    :polymorphic => true

  after_destroy :remove_resource_from_xml

  validates_uniqueness_of :duck_id, :scope => [:path, :resource_id]

  def remove_resource_from_xml
    resource = duck.base.find_by_path path
    resource and resource.destroy and duck.save
  end

end
