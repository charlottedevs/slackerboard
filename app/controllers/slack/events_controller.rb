module Slack
  class EventsController < ActionController::API
    def create
      if params['challenge'].present?
        render json: { challenge: params['challenge'] }
      else
        ProcessSlackEvent.call(event_params)
        render json: { status: 'ok' }
      end
    end

    private

    def event_params
      params.permit! # yep, TODO
    end
  end
end
