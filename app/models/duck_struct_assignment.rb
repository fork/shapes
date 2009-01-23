class DuckStructAssignment < ActiveRecord::Base

  belongs_to :duck_struct
  belongs_to :duck

  after_destroy :remove_struct_from_xml

  validates_uniqueness_of :duck_id, :scope => [:path, :duck_struct_id]

  def remove_struct_from_xml
    resource = duck.base.find_by_path path
    resource and resource.destroy and duck.save
  end

end
