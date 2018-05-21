class CreateSlackMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_messages do |t|
      t.references :slack_channel, foreign_key: true
      t.references :user, foreign_key: true
      t.string :ts

      t.timestamps
    end
  end
end
