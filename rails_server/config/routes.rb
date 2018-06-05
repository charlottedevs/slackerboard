Rails.application.routes.draw do
  get 'slackers', to: 'slackers#index'
  post 'slack/events', to: 'slack/events#create'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
