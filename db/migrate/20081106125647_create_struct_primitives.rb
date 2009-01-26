class CreateStructPrimitives < ActiveRecord::Migration
  def self.up
    create_table :shape_struct_primitives do |t|
      t.string :ident, :null => false
      t.string :primitive, :null => false
      t.belongs_to :shape_struct
      t.timestamps
    end
  end

  def self.down
    drop_table :shape_struct_primitives
  end
end
