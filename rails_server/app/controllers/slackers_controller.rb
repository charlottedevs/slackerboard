class SlackersController < ApplicationController
  def index
    render json: { slackerboard: Slackerboard.new.to_json }
  end
end
