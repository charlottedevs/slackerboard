class User < ApplicationRecord
  has_many :slack_messages
  has_many :slack_reactions
  has_many :slack_channels, through: :slack_messages

  def self.slackers
    User.left_outer_joins(:slack_messages, :slack_reactions)
        .group('users.id')
        .having('count(slack_messages.user_id) > 0 OR count(slack_reactions.user_id) > 0')
        .group(:id)
        .order(Arel.sql 'count(slack_messages.user_id) DESC')
  end
end
