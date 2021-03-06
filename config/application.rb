# frozen_string_literal: true

require_relative 'boot'

require 'rails'

require 'good_job/engine'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# backend for devise
module RailsDeviseBackend
  # main application
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths << "#{Rails.root}/lib"


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.session_store :cookie_store, key: '_test_app_cookie_session', secure: Rails.env.production?

    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # active job
    config.active_job.queue_adapter = :good_job
    config.good_job.execution_mode = :async
    config.good_job.max_threads = 20


    config.active_record.legacy_connection_handling = false
    config.action_controller.per_form_csrf_tokens = true
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
  end
end
