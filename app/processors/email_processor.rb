class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process(token: nil)
    return unless feed_token

    Post.create!(
      feed: Feed.where(token: feed_token).first || (Rails.env.development? && Feed.order(:updated_at).last),
      payload: @email.to_h,
      token: token
    )
  end

  def feed_token
    contact = @email.to.find{|t| t[:host] == "feedyour.email" }
    contact && contact[:token]
  end
end
