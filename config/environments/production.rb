require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = {"cache-control" => "public, max-age=#{1.year.to_i}"}

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true unless ENV.key?("ALLOW_HTTP")

  # Action Cable — single-process Fly deployment uses in-process async adapter.
  # For multi-process, switch to `redis://...` or `postgresql://...`.
  config.action_cable.url = "wss://feedyour.email/cable"
  config.action_cable.allowed_request_origins = ["https://feedyour.email"]

  # Render 404/500 pages via :rescuable; Honeybadger still receives exceptions
  # via Honeybadger::Rack::ErrorNotifier's framework_exception hook.
  config.action_dispatch.show_exceptions = :rescuable

  # Better Honeybadger ↔ query correlation.
  config.active_record.query_log_tags_enabled = true

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Default log level.
  config.log_level = :info

  # Use LiteCache (litestack) instead of the default in-memory cache.
  config.cache_store = :litecache

  # Use LiteJob (litestack) instead of the default in-process queuing backend.
  config.active_job.queue_adapter = :litejob

  # Enable locale fallbacks for I18n.
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Log to STDOUT when RAILS_LOG_TO_STDOUT is set.
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Concise request logging.
  config.lograge.enabled = true

  # Action Mailbox Postmark ingress
  config.action_mailbox.ingress = :postmark
  config.action_mailbox.incinerate_after = 1.minute
end
