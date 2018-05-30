class Slackerboard
  attr_reader :since

  def initialize(*args, since: nil)
    @since = since
  end

  def to_json
    to_builder.array!
  end

  def to_builder
    Jbuilder.new do |json|
      json.array! users do |user|
        json.extract!(user,
                      :id,
                      :slack_identifier,
                      :real_name,
                      :slack_handle,
                      :profile_image)

        json.messages user.message_summary(since: since)  do |summary|
          json.channel summary.channel
          json.slack_identifier summary.channel_slack_identifier
          json.messages_sent summary.messages_given
        end

        json.reactions user.reaction_summary(since: since)  do |summary|
          json.emoji summary.emoji
          json.reactions_given summary.reactions_given
        end
      end
    end
  end

  def users
    @users ||= User
      .includes(:channel_usages, :reaction_usages)
      .slackers(since: since)
  end
end
