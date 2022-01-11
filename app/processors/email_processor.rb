class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    to = @email.to.find{|t| t[:host] == "feedyour.email" }
    feed_id = to[:token] if to
    return unless feed_id

    feed_id = Feed.last.id if feed_id == "somefeed"
    Feed.where(token: feed_id).first.posts.create!(payload: @email.to_h)
  end
end
