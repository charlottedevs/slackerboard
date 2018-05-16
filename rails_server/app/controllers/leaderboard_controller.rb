class LeaderboardController < ApplicationController
  def index
    # TODO sort
    @users = User.all
  end
end
