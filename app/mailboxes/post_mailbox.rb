class PostMailbox < ApplicationMailbox
  include ActionView::RecordIdentifier

  def process(token: nil)
    return if postmark_test? || feed_token.nil?

    post = Post.create!(
      feed: feed,
      token: token,
      from: mail.from_address,
      subject: mail.subject,
      html_body: mail.html_part.decoded,
      text_body: mail.text_part.decoded
    )

    post.broadcast_prepend_to(feed, :posts)
    feed.broadcast_replace_to(
      feed,
      target: dom_id(feed, "count"),
      partial: "feeds/feed_count",
      locals: {feed: feed}
    )
  end

  def feed
    Feed.find_by!(token: feed_token)
  end

  def feed_token
    mail.recipients_addresses.find { |a| a.domain == "feedyour.email" }&.local ||
      raise("Unknown address #{mail.to_addresses.inspect}")
  end

  private

  def postmark_test?
    mail.from.include?("support@postmarkapp.com") &&
      mail.to.include?("mailbox+SampleHash@inbound.postmarkapp.com")
  end
end
