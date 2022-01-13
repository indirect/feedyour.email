class EmailProcessor
  cattr_accessor :default_to_newest_feed, default: false

  def initialize(email)
    @email = email
  end

  def process(token: nil)
    raise unless feed

    Post.create!(feed: feed, payload: @email.to_h, token: token)
  end

  def feed
    @feed ||= Feed.where(token: feed_token).first
    @feed ||= Feed.order(:updated_at).last if default_to_newest_feed
  end

  def feed_token
    contact = @email.to.find { |t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end
end
