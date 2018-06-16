class SlackEventWorker
  include Sidekiq::Worker

  def perform(event)
    result = ProcessSlackEvent.call(event: event)
    if result.success?
      broadcast
    else
      logger.fatal "Slack Event Failure! #{result.error}"
    end
  end

  private

  def broadcast
    ActionCable.server.broadcast(
      'all_time_slackerboard_update',
      slackerboard: SlackerRanking.new.to_json
    )
    ActionCable.server.broadcast(
      'this_week_slackerboard_update',
      slackerboard: SlackerRanking.new(since: Time.zone.today.monday).to_json
    )
  end
end
