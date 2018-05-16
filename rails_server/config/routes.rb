Rails.application.routes.draw do
  get 'slackers/index'
  get 'leaderboard/index'
  get '/', to: 'leaderboard#index'
  post 'slack/events', to: 'slack/events#create'
end
