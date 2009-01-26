class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :shape_assignments do |t|
      t.references :resource, :null => false, :polymorphic =>true
      t.references :shape, :null => false
      t.string :path, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :shape_assignments
  end
end
