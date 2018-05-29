class SlackEventWorker
  include Sidekiq::Worker

  def perform(json)
    event_params = JSON.parse(json)
    result = ProcessSlackEvent.call(event_params)
    if result.success?
      broadcast
    else
      Rails.logger.error "Slack Event Failure! #{result.error}"
    end
  end

  private

  def broadcast
    ActionCable.server.broadcast(
      'all_time_slackerboard_update',
      slackerboard: Slackerboard.new.to_json
    )
    ActionCable.server.broadcast(
      'this_week_slackerboard_update',
      slackerboard: Slackerboard.new(since: Date.today.monday).to_json
    )
  end
end
