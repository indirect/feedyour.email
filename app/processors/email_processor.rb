class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    return unless feed_token

    Post.create!(
      feed: Feed.where(token: feed_token).first,
      payload: @email.to_h
    )
  end

  def feed_token
    contact = @email.to.find{|t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end
end
