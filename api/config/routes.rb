Rails.application.routes.draw do
  get 'slackers', to: 'slackers#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
