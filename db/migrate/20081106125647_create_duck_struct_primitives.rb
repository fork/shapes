class CreateDuckStructPrimitives < ActiveRecord::Migration
  def self.up
    create_table :duck_struct_primitives do |t|
      t.string :ident, :null => false
      t.string :primitive, :null => false
      t.belongs_to :duck_struct
      t.timestamps
    end
  end

  def self.down
    drop_table :duck_struct_primitives
  end
end
