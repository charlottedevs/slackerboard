class CreateSlackChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_channels do |t|
      t.string :slack_identifier, null: false, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
