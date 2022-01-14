class EmailProcessor
  cattr_accessor :default_to_newest_feed, default: false
  attr_writer :feed

  def self.for_payload(payload, feed: nil)
    json = JSON.parse(payload)
    params = Griddler::Postmark::Adapter.normalize_params(json.deep_symbolize_keys)
    email = Griddler::Email.new(params)
    new(email, feed: feed)
  end

  def initialize(email, feed: nil)
    @email = email
    @feed = feed
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
