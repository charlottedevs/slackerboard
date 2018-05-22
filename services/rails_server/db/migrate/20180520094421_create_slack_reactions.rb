class CreateSlackReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_reactions do |t|
      t.references :user, foreign_key: true
      t.string :emoji, null: false, index: true
      t.string :target, null: false, index: true
      t.string :slack_identifier, null: false, index: true

      t.timestamps
    end
  end
end
