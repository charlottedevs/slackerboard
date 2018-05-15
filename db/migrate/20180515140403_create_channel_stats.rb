class CreateChannelStats < ActiveRecord::Migration[5.2]
  def change
    create_table :channel_stats do |t|
      t.references :slack_channel, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.integer :messages_given
      t.integer :reactions_given

      t.timestamps
    end
  end
end
