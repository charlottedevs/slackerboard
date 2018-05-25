class AddSlackCounts < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_messages_count, :integer, default: 0
    add_column :users, :slack_reactions_count, :integer, default: 0
  end
end
