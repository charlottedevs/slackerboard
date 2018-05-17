class ProcessSlackEvent
  include Interactor

  def call
    if message_created?
      update_stat!(:messages_given, 1)
    elsif message_deleted?
      update_stat!(:messages_given, -1)
    elsif reaction_given?
      update_stat!(:reactions_given, 1)
    elsif reaction_removed?
      update_stat!(:reactions_given, -1)
    end
  end

  private

  def update_stat!(attr, delta)
    result = metric.send(attr) + delta
    return unless result >= 0 # no going into debt
    metric.update!(attr => result)
  end

  def metric
    context.stat ||= init_metric
  end

  def init_metric
    if message?
      ChannelStat.find_or_create_by(
        slack_channel_id: channel.id, user_id: user.id
      )
    else
      ReactionStat.find_or_create_by(emoji: reaction_emoji, user_id: user.id)
    end
  end

  def channel
    context.channel ||= SlackChannel.find_or_create_by(
      slack_identifier: event['channel']
    )
  end

  def user
    context.user ||= User.find_or_create_by(slack_identifier: event['user'])
  end

  def message?
    message_created? || messaged_delted?
  end

  def reaction?
    reaction_given? || reaction_removed?
  end

  def reaction_emoji
    event['reaction']
  end

  def message_created?
    message? && !event_subtype.present?
  end

  def message_deleted?
    message? && event_subtype == 'message_deleted'
  end

  def reaction_given?
    event_type == 'reaction_added'
  end

  def reaction_removed?
    event_type == 'reaction_removed'
  end

  def message?
    event_type == 'message'
  end

  def event_type
    event['type']
  end

  def event_subtype
    event['subtype']
  end

  def event
    context.event
  end
end
