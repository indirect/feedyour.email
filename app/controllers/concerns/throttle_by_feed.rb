module ThrottleByFeed
  extend ActiveSupport::Concern

  included do
    before_action :throttle_by_feed
  end

  def throttle_by_feed
    feed_id = params[:OriginalRecipient]&.split("@")&.first
    feed = feed_id && Feed.find_by(token: feed_id)
    return head(:forbidden) unless feed

    # allow first 24 hours of setup to include however many emails
    return if 1.day.ago < feed.created_at

    # reject emails after 14 in one week
    week_post_count = feed.posts.where("created_at > ?", 1.week.ago).count

    if week_post_count >= 14
      feed.update!(throttled_at: Time.now.utc)
      return head(:forbidden)
    end

    feed.update!(throttled_at: nil) if feed.throttled_at?
  end
end
