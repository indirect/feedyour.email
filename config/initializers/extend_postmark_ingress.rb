Rails.application.config.after_initialize do
  ActionMailbox::BaseController.include ThrottleByFeed
end
