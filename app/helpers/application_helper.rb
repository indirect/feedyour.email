module ApplicationHelper
  def page_title
    if content_for?(:page_title)
      "#{content_for(:page_title)} — Feed Your Email"
    else
      "Feed Your Email".freeze
    end
  end

  def sharing_meta_tags(title: "Feed Your Email")
    if content_for?(:page_favicon)
      return if content_for(:page_favicon).nil?

      return [
        tag.link(rel: "icon", href: content_for(:page_favicon)),
        tag.link(rel: "apple-touch-icon", href: content_for(:page_favicon))
      ].join("\n").html_safe # rubocop:disable Rails/OutputSafety
    end

    description = "Generate an email address you can use for any newsletter, and a corresponding feed you can use to read those emails."
    image = root_url + "card.jpg"

    [
      # OpenGraph
      tag.meta(property: "og:title", content: title),
      tag.meta(property: "og:description", content: description),
      tag.meta(property: "og:url", content: root_url),
      tag.meta(property: "og:image", content: image),
      tag.meta(property: "og:site_name", content: title),
      tag.meta(property: "og:locale", content: "en_US"),
      tag.meta(property: "og:type", content: "website"),
      # Twitter
      tag.meta(property: "twitter:card", content: "summary_large_image"),
      tag.meta(property: "twitter:title", content: title),
      tag.meta(property: "twitter:description", content: description),
      tag.meta(property: "twitter:image", content: image),
      tag.meta(property: "twitter:site", content: root_url),
      tag.meta(property: "twitter:creator", content: "@indirect"),

      # Icons
      tag.link(rel: "icon", type: "image/svg+xml", href: "/favicon.svg")
    ].join("\n").html_safe # rubocop:disable Rails/OutputSafety
  end
end
