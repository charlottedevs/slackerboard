module Slack
  class EventsController < ActionController::API
    before_action :verify!

    def create
      if params['challenge'].present?
        render json: { challenge: params['challenge'] }
      else
        SlackEventWorker.perform_async(params.to_json)
        render json: { status: 'created' }, status: :created
      end
    end

    private

    def verify!
      return if authorized?
      render json: { status: 'unauthorized' }, status: :unauthorized
    end

    def authorized?
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(params['token'].to_s),
        ::Digest::SHA256.hexdigest(verification_token))
    end

    def verification_token
      ENV.fetch('SLACK_VERIFICATION_TOKEN')
    end
  end
end
