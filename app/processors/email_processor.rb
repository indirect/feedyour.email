class EmailProcessor
  def self.from_payload(payload)
    json = JSON.parse(payload)
    params = Griddler::Postmark::Adapter.normalize_params(json.deep_symbolize_keys)
    email = Griddler::Email.new(params)
    new(email)
  end

  def initialize(email)
    @email = email
  end

  def process(token: nil)
    feed.update!(domain: @email.from[:host])
    Post.create!(feed: feed, payload: @email.to_h, token: token)
  end

  def feed
    Feed.find_by!(token: feed_token)
  end

  def feed_token
    contact = @email.to.find { |t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end
end
