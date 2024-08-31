module ThrottleByFeed
  extend ActiveSupport::Concern

  included do
    before_action :throttle_by_feed
  end

  def throttle_by_feed
    # require an active feed to accept this email
    feed_id = params[:OriginalRecipient]&.split("@")&.first
    feed = feed_id && Feed.find_by(token: feed_id)
    return head(:forbidden) if feed.nil? || feed.expired?

    # allow first 24 hours of setup to include however many emails
    return if 1.day.ago < feed.created_at

    week_count = feed.week_posts.count

    # reject emails after 14 in one week
    if week_count >= 14
      feed.throttle!
      return head(:forbidden)
    end

    # unthrottle if previously throttled
    feed.unthrottle!
  end
end
