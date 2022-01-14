class EmailProcessor
  cattr_accessor :default_to_newest_feed, default: false

  def initialize(email)
    @email = email
  end

  def process(token: nil)
    Post.create!(feed: Feed.find_by(token: feed_token), payload: @email.to_h, token: token)
  end

  def feed_token
    contact = @email.to.find { |t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end
end
