class CreateReactionUsages < ActiveRecord::Migration[5.2]
  def change
    create_view :reaction_usages
  end
end
