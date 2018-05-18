class SlackEventWorker
  include Sidekiq::Worker

  def perform(json)
    event_params = JSON.parse(json)
    result = ProcessSlackEvent.call(event_params)
    if result.success?
      ActionCable.server.broadcast('slackerboard_change', slackerboard: Slackerboard.new)
    else
      Rails.logger.error "Slack Event Failure! #{result.error}"
    end
  end
end
