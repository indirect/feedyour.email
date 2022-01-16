class EmailProcessor
  def initialize(email = nil, payload: nil)
    raise ArgumentError unless email || payload
    @email = payload ? parse_payload(payload) : email
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

  private

  def email_from_payload(payload)
    json = JSON.parse(payload).deep_symbolize_keys
    params = Griddler::Postmark::Adapter.normalize_params(json)
    Griddler::Email.new(params)
  end
end
