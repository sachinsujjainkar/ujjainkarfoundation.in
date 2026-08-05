require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ujjainkarfoundation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = "Mumbai"

    # Marathi is the source of record; the mr locale is the application default.
    config.i18n.available_locales = [ :mr, :en ]
    config.i18n.default_locale = :mr

    # Bilingual, styled 404/500 (ErrorsController) instead of Rails' static
    # public/404.html and public/500.html -- see
    # docs/prompts/phase-03-layout-shell.md. The static files stay in place
    # as the last-resort fallback for failures that happen before routing
    # even works (e.g. the app failing to boot).
    config.exceptions_app = routes
  end
end
