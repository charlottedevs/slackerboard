class SlackersController < ApplicationController
  def index
    render json: { slackerboard: slackerboard.to_json }
  end

  private

  def slackerboard
    if this_week?
      Slackerboard.new(since: Time.zone.today.monday)
    else
      Slackerboard.new
    end
  end

  def this_week?
    params.keys.include? 'thisweek'
  end
end
