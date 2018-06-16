$stdout.sync = true

class LurkerBot
  class << self
    def start
      load_listeners
      Rails.logger.debug 'starting LurkerBot....'
      client.start!
    end

    def client
      @client ||= Slack::RealTime::Client.new
    end

    def config
      @config ||= client.web_client.auth_test
    end

    delegate :user_id, :team_id, :user, to: :config

    def load_listeners
      %i(
      reaction_added
      reaction_removed
      ).each do |event|
        client.on event do |data|
          Rails.logger.debug data.as_json
          SlackEventWorker.perform_async(data)
        end
      end

      client.on :message do |data|
        Rails.logger.debug data.as_json
        SlackEventWorker.perform_async(data)

        if spoken_to?(data)
          client.message channel: data.channel, text: "<@#{data.user}>, sorry I'm a lurker"
        end
      end
    end

    private

    def spoken_to?(data)
      mention?(data) || direct_message?(data)
    end

    def mention?(data)
      data.text.to_s.include?  user_id
    end

    def direct_message?(data)
      data.user != user_id && data.channel && data.channel[0] == 'D'
    end
  end
end


