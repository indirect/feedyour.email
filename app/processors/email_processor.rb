class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    feed_id = @email.to.find{|t| t[:host] == "feedyour.email" }[:token]
    feed_id = Feed.last.id if feed_id == "somefeed"
    Feed.find(feed_id).posts.create!(payload: @email.to_h)
  end
end
