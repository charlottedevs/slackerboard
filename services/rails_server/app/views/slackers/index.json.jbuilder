json.array! @slackers do |user|
  json.extract!(user,
                :id,
                :slack_identifier,
                :real_name,
                :slack_handle,
                :profile_image)

  json.messages user.channel_stats do |channel|
    json.channel channel.slack_channel.name
    json.slack_identifier channel.slack_channel.slack_identifier
    json.messages_sent channel.messages_given
  end
end
