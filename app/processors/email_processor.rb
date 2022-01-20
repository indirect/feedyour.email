class EmailProcessor
  include ActionView::RecordIdentifier

  def initialize(email = nil, payload: nil)
    raise ArgumentError unless !email ^ !payload
    @email = email || email_from_payload(payload)
  end

  def process(token: nil)
    return if postmark_test?

    post = Post.create!(feed: feed, payload: @email.to_h, token: token)

    post.broadcast_prepend_to(feed, :posts)
    feed.broadcast_replace_to(feed, target: dom_id(feed, "count"), partial: "feeds/feed_count", locals: {feed: feed})
  end

  def feed
    Feed.find_by!(token: feed_token)
  end

  def feed_token
    contact = @email.to.find { |t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end

  private

  def email_from_payload(payload)
    json = JSON.parse(payload).deep_symbolize_keys
    params = Griddler::Postmark::Adapter.normalize_params(json)
    Griddler::Email.new(params)
  end

  def postmark_test?
    @email.from[:email] == "support@postmarkapp.com" &&
      @email.to.find { |t| t[:email] == "mailbox+SampleHash@inbound.postmarkapp.com" }
  end
end
