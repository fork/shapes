class CreateStructs < ActiveRecord::Migration
  def self.up
    create_table :shape_structs do |t|
      t.string :name, :null => false
      t.belongs_to :shape
      t.timestamps
    end
    add_index :shape_structs, :name
    add_index :shape_structs,
      [:id, :shape_id],
      :unique => true, :name => 'struct_shape_index'
  end

  def self.down
    drop_table :shape_structs
  end
end
