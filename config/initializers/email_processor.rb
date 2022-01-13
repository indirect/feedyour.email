Rails.application.config.to_prepare do
  EmailProcessor.default_to_newest_feed = Rails.env.development?
end
