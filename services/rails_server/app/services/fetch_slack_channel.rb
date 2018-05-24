class FetchSlackChannel
  include Interactor

  SLACK_API = "https://slack.com/api/channels.info"

  def call
    context.channel = SlackChannel.find_or_create_by(slack_identifier: context.slack_identifier) do |channel|
      json = JSON.parse(res.body)
      if json['ok']
        channel.name = json.dig('channel', 'name')
      else
        raise ArgumentError, json['error']
      end
    end
  end

  private

  def res
    context.res ||= Faraday.get(slack_url)
  end

  def slack_url
    "#{SLACK_API}?token=#{token}&channel=#{context.slack_identifier}"
  end

  def token
    ENV.fetch('SLACK_API_TOKEN')
  end
end
