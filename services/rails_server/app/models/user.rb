class User < ApplicationRecord
  has_many :slack_messages
  has_many :slack_reactions
  has_many :slack_channels, through: :slack_messages

  scope :by_slack_messages, -> { order('slack_messages_count DESC') }
  scope :by_slack_reactions, -> { order('slack_reactions_count DESC') }


  def self.slackers
    User.left_outer_joins(:slack_messages, :slack_reactions)
        .group('users.id')
        .having('count(slack_messages.user_id) > 0 OR count(slack_reactions.user_id) > 0')
        .by_slack_messages
  end

  def update_slack_info
    UpdateSlackUser.call(user: self)
  end

  def update_slack_info!
    UpdateSlackUser.call(user: self, save: true)
  end
end
