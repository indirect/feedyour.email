class PostMailbox < ApplicationMailbox
  include ActionView::RecordIdentifier

  def process(token: nil)
    return if postmark_test? || feed_token.nil?

    post = Post.create!(
      feed: feed,
      token: token,
      from: mail.from_address,
      subject: mail.subject,
      html_body: html_body,
      text_body: text_body
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
      received_header_token || raise("Unknown address! #{mail.to_addresses.map(&:to_s).inspect}")
  end

  private

  def received_header_token
    tokens = mail.header
      .select { |h| h.name == "Received" }
      .map { |h| h.value.scan(/for <(.*?)@feedyour.email>/) }
      .flatten
      .uniq

    return nil if tokens.size.zero?
    return tokens.first if tokens.size == 1
    raise("Too many feeds! #{tokens.inspect}")
  end

  def postmark_test?
    mail.from.include?("support@postmarkapp.com") &&
      mail.to.include?("mailbox+SampleHash@inbound.postmarkapp.com")
  end

  def text_body
    return mail.text_part.decoded if mail.text_part
    (mail.mime_type == "text/plain") ? mail.body.decoded : nil
  end

  def html_body
    return mail.html_part.decoded if mail.html_part
    (mail.mime_type == "text/html") ? mail.body.decoded : nil
  end
end
