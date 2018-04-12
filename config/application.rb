require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DistAdmin
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Moscow'
    # I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :ru]

    #config.middleware.use Rack::Locale
    config.middleware.use Rack::TempfileReaper
  end
end
