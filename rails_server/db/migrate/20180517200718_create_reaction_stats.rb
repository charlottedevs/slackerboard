class CreateReactionStats < ActiveRecord::Migration[5.2]
  def change
    create_table :reaction_stats do |t|
      t.string :emoji
      t.references :user, foreign_key: true
      t.integer :reactions_given, default: 0

      t.timestamps
    end

    remove_column :channel_stats, :reactions_given
  end
end
