class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :shape_assignments do |t|
      t.references :resource, :null => false, :polymorphic =>true
      t.references :shape, :null => false
      t.string :path, :null => false
      t.timestamps
    end
    add_index :shape_assignments, 
      [:resource_type, :path], 
      :unique => true
  end

  def self.down
    drop_table :shape_assignments
  end
end
