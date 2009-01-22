class CreateDuckAppearances < ActiveRecord::Migration
  def self.up
    create_table :duck_appearances do |t|
      t.string :appearance_type, :null => false
      t.integer :appearance_id, :null => false
      t.belongs_to :duck
      t.string :path, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :duck_appearances
  end
end
