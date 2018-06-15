class ProcessSlackEvent
  include Interactor

  def call
    process
  rescue => error
    context.fail!(error: error.message)
  end

  private

  def process
    if message_created?
      create_message
    elsif message_deleted?
      destroy_message
    elsif reaction_given?
      create_reaction if channel
    elsif reaction_removed?
      destroy_reaction if channel
    end
  end

  def create_message
    SlackMessage.create(
      user_id: user.id,
      slack_channel_id: channel.id,
      ts: event['ts']
    )
  end

  def destroy_message
    SlackMessage.where(
      slack_channel_id: channel.id,
      ts: event['deleted_ts']
    ).destroy_all
  end

  def create_reaction
    SlackReaction.create(
      user_id: user.id,
      emoji: emoji,
      target: type,
      slack_identifier: slack_identifier,
      slack_channel_id: channel.id
    )
  end

  def destroy_reaction
    SlackReaction.where(
      emoji: emoji,
      slack_identifier: slack_identifier
    ).destroy_all
  end

  def emoji
    event['reaction']
  end

  def type
    event.dig('item', 'type')
  end

  def slack_identifier
    event.dig('item', identifier_key)
  end

  def identifier_key
    case type
    when 'message' then 'ts'
    when 'file' then 'file'
    when 'file_comment' then 'file_comment'
    else
      raise "unknown reaction type: #{type}"
    end
  end

  def channel
    context.channel ||= FetchSlackChannel.call(slack_identifier: slack_channel_id).channel
  end

  def slack_channel_id
    event['channel'] || event.dig('item', 'channel')
  end

  def user
    context.user ||= FetchSlackUser.call(slack_identifier: event['user']).user
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
