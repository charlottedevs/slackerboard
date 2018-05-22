class SlackersController < ApplicationController
  def index
    render json: { slackerboard: Slackerboard.new }
  end
end
