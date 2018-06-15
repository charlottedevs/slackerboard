class CreateChannelUsages < ActiveRecord::Migration[5.2]
  def change
    create_view :channel_usages
  end
end
