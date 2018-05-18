class User < ApplicationRecord
  has_many :channel_stats
  has_many :reaction_stats
  has_many :slack_channels, through: :channel_stats

  def self.slackers
    left_outer_joins(:channel_stats, :reaction_stats).where('channel_stats.messages_given > ? OR reaction_stats.reactions_given > ?', 0, 0).group(:id).order(Arel.sql 'SUM(channel_stats.messages_given) ASC')
  end
end
