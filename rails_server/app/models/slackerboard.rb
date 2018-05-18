class Slackerboard
  class << self
    def new(*args)
      Rails.cache.fetch('slackerboard') do
        to_builder.array!
      end
    end

    private

    def to_builder
      Jbuilder.new do |json|
        json.array! User.slackers do |user|
          json.extract!(user,
                        :id,
                        :slack_identifier,
                        :real_name,
                        :slack_handle,
                        :profile_image)

          json.messages user.channel_stats.where('messages_given > ?', 0) do |channel|
            json.channel channel.slack_channel.name
            json.slack_identifier channel.slack_channel.slack_identifier
            json.messages_sent channel.messages_given
          end

          json.reactions user.reaction_stats.where('reactions_given > ?', 0) do |reaction|
            json.emoji reaction.emoji
            json.reactions_given reaction.reactions_given
          end
        end
      end
    end
  end
end
