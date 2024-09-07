# This concern is included into the ActionMailbox ingress controller for
# Postmark. It adds a preprocessing step during the incoming webhook request,
# which allows us to return a 403 status to Postmark, signaling that the email
# should not be tried again. The email processor runs too late to do that.
module ThrottleByFeed
  extend ActiveSupport::Concern

  included do
    before_action :throttle_by_feed
  end

  def throttle_by_feed
    # require an active feed to accept this email
    feed_id = params[:OriginalRecipient]&.split("@")&.first
    feed = feed_id && Feed.find_by(token: feed_id)
    feed&.expire_if_stale!
    return head(:forbidden) if feed.nil? || feed.expired_at?

    # allow first 24 hours of setup to include however many emails
    return if 1.day.ago < feed.created_at

    week_count = feed.week_posts.count

    # reject emails after 14 in one week
    if week_count >= Rails.configuration.feed_week_limit
      feed.throttle!
      head(:forbidden)
    else
      # unthrottle if previously throttled
      feed.unthrottle!
    end
  end
end
