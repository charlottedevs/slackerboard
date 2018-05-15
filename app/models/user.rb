class User < ApplicationRecord
  has_many :channel_stats
  has_many :slack_channels, through: :channel_stats
end
