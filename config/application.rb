require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FeedyourEmail
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_record.yaml_column_permitted_classes = [
      Mail::Address,
      Mail::Parsers::AddressListsParser::AddressStruct,
      Symbol
    ]

    # Used for system announcements or warnings made by Feed#create_post
    config.system_email = Mail::Address.new("Feed Your Email <system@feedyour.email>")

    # Used in ThrottleByFeed, this is the limit of emails accepted into a feed per week
    config.week_limit = 14
  end
end

# Add incoming mail auth for local dev and system tests
if Rails.env.local?
  Rails.application.credentials.action_mailbox ||= ActiveSupport::OrderedOptions.new
  Rails.application.credentials.action_mailbox.ingress_password = "abc123"
end
