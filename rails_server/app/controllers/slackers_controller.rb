class SlackersController < ApplicationController

  def index
    render json: Slackerboard.new.to_json
  end
end
