module Slack
  class EventsController < ActionController::API
    def create
      if params['challenge'].present?
        render json: { challenge: params['challenge'] }
      else
        SlackEventWorker.perform_async(params.to_json)
        render json: { status: 'ok' }
      end
    end
  end
end
