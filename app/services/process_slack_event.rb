class ProcessSlackEvent
  include Interactor

  def call
    if message_created?
      stat.increment(:messages_given)
    elsif message_deleted?
      stat.decrement(:messages_given)
    elsif reaction_given?
      stat.increment(:reactions_given)
    elsif reaction_removed?
      stat.decrement(:reactions_given)
    end
  end

  private

  def stat
    context.stat ||= ChannelStat.find_or_create_by(
      slack_channel_id: channel.id, user_id: user.id
    )
  end

  def channel
    context.channel ||= SlackChannel.find_or_create_by(
      slack_identifier: event['channel']
    )
  end

  def user
    context.user ||= User.find_or_create_by(slack_identifier: event['user'])
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
