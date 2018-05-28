class SlackersController < ApplicationController
  def index
    render json: { slackerboard: slackerboard }
  end

  private

  def slackerboard
    args = { this_week: true } if this_week?
    Slackerboard.new(args).to_json
  end

  def this_week?
    params.keys.include? 'thisweek'
  end
end
