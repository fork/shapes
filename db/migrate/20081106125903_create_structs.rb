class CreateStructs < ActiveRecord::Migration
  def self.up
    create_table :shape_structs do |t|
      t.string :name, :null => false
      t.integer :shape_id
      t.timestamps
    end
  end

  def self.down
    drop_table :shape_structs
  end
end
