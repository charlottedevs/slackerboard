class ChannelStat < ApplicationRecord
  belongs_to :slack_channel
  belongs_to :user
end
