class DuckStructAssignment < ActiveRecord::Base

  belongs_to :duck_struct
  belongs_to :duck
  
  validates_uniqueness_of :duck_id, :scope => [:path, :duck_struct_id]

end
