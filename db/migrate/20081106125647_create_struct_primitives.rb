class CreateStructPrimitives < ActiveRecord::Migration
  def self.up
    create_table :shape_struct_primitives do |t|
      t.string :ident, :null => false
      t.string :primitive, :null => false
      t.string :restrictions
      t.belongs_to :shape_struct
      t.timestamps
    end
    add_index :shape_struct_primitives,
      [:id, :shape_struct_id],
      :unique => true, :name => 'primitive_struct_index'
  end

  def self.down
    drop_table :shape_struct_primitives
  end
end
