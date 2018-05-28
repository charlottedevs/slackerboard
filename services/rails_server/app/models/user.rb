class User < ApplicationRecord
  has_many :slack_messages
  has_many :slack_reactions
  has_many :slack_channels, through: :slack_messages

  scope :by_slack_messages, lambda {
    order(
      'slack_messages_count DESC, slack_reactions_count DESC, slack_handle'
    )
  }

  scope :by_slack_reactions, lambda {
    order(
      'slack_reactions_count DESC, slack_messages_count DESC, slack_handle'
    )
  }

  def self.slackers(this_week: false)
    if this_week
      self.slackers_this_week_query
    else
      self.slackers_all_time_query
    end
  end

  def update_slack_info
    UpdateSlackUser.call(user: self)
  end

  def update_slack_info!
    UpdateSlackUser.call(user: self, save: true)
  end

  def self.slackers_this_week_query
    User.joins(:slack_messages, :slack_reactions)
      .where('slack_messages.created_at >= ?', Slackerboard.this_monday)
      .group('users.id')
      .having('count(slack_messages.user_id) > 0')
      .order(
        Arel.sql 'count(slack_messages) DESC, count(slack_reactions) DESC, slack_handle'
      )
      .by_slack_messages
      .limit(50)
  end

  def self.slackers_all_time_query
    User.joins(:slack_messages)
      .group('users.id')
      .having('count(slack_messages.user_id) > 0')
      .by_slack_messages
      .limit(50)
  end
end
