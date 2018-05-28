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

        json.messages user.message_summary(since: since)  do |(channel, id), v|
          json.channel channel
          json.slack_identifier id
          json.messages_sent v.to_i
        end

        json.reactions user.reaction_summary(since: since)  do |k, v|
          json.emoji k
          json.reactions_given v.to_i
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
