class CreateDuckStructs < ActiveRecord::Migration
  def self.up
    create_table :duck_structs do |t|
      t.string :name, :null => false
      t.integer :duck_id
      t.timestamps
    end
  end

  def self.down
    drop_table :duck_structs
  end
end
