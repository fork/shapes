class DuckAppearance < ActiveRecord::Base

  belongs_to :duck
  belongs_to :appearance, :polymorphic => true

end

