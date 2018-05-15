module Slack
  class EventsController < ActionController::API
    def create
      ProcessSlackEvent.call(event_params)
    end

    private

    def event_params
      params.permit! # yep, TODO
    end
  end
end
