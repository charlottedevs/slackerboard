require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load unless Rails.env.production?

module Slackerboard
  class Application < Rails::Application
    config.api_only = true
    config.time_zone = 'Eastern Time (US & Canada)'
    config.filter_parameters += [:token]

    config.eager_load_paths << Rails.root.join('lib')

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
