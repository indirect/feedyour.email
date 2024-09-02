class PostMailbox < ApplicationMailbox
  include ActionView::RecordIdentifier

  def process(token: nil)
    return if postmark_test? || feed_token.nil?

    post = Post.create!(
      feed: feed,
      token: token,
      from: mail.from_address,
      subject: mail.subject,
      compressed_html_body: html_body,
      compressed_text_body: text_body
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
    if mail.text_part
      mail.text_part.decoded
    elsif mail.mime_type == "text/plain"
      mail.decoded
    end
  end

  def html_body
    if mail.multipart? && mail.parts.first.multipart?
      depart(mail.parts.first)
    elsif mail.html_part
      mail.html_part.decoded
    elsif mail.mime_type == "text/html"
      mail.decoded
    end
  end

  def depart(mail)
    body = mail.html_part.decoded
    attachments = mail.parts.select(&:content_id)
    document = Nokogiri::HTML(body)

    attachments.map do |attachment|
      element = document.at_css "img[src='cid:#{attachment.content_id[1...-1]}']"
      content = Base64.strict_encode64 attachment.body.decoded
      element["src"] = "data:#{attachment.mime_type};base64,#{content}"
    end

    document.to_s
  end
end
