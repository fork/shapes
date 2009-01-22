# QUESTION: What for? Please add docs here.
class DuckAppearance < ActiveRecord::Base

  belongs_to :duck
  belongs_to :appearance, :polymorphic => true

end
