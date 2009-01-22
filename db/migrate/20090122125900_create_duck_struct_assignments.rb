class CreateDuckStructAssignments < ActiveRecord::Migration
  def self.up
    create_table :duck_struct_assignments do |t|
      t.integer :duck_struct_id, :null => false
      t.integer :duck_id, :null => false
      t.string :path, :null => false
    end
  end

  def self.down
    drop_table :duck_struct_assignments
  end
end
