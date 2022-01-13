class EmailProcessor
  cattr_accessor :default_to_newest_feed, default: false

  def initialize(email)
    @email = email
  end

  def process(token: nil)
    Post.create!(feed: feed, payload: @email.to_h, token: token)
  end

  def feed
    @feed ||= Feed.find_by(token: feed_token)
  end

  def feed_token
    contact = @email.to.find { |t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end
end
