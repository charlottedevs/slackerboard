Rails.application.routes.draw do
  get 'slackers', to: 'slackers#index'
  post 'slack/events', to: 'slack/events#create'
end
