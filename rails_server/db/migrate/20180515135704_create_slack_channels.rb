class CreateSlackChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :slack_channels do |t|
      t.string :slack_identifier
      t.string :name

      t.timestamps
    end
  end
end
