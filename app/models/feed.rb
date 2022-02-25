class Feed < ApplicationRecord
  has_many :posts, -> { order(updated_at: :desc) },
    dependent: :destroy, inverse_of: :feed
  has_one :last_post, -> { order(updated_at: :desc) },
    class_name: "Post", dependent: nil, inverse_of: :feed
  has_secure_token :token
  nilify_blanks

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length)
  end

  def name
    read_attribute(:name) || "Feed Your Email #{token}" if token
  end

  def to_param
    token
  end

  def fetched_at
    read_attribute(:fetched_at) || created_at
  end

  def expired?
    return false unless fetched_at
    Time.current.after? fetched_at.next_year
  end

  def domain
    return unless last_post
    return last_post.from_email.tr("@", ".") if last_post.domain == "substack.com"

    {
      "mail.bloombergview.com" => "bloomberg.com",
      "nl.npr.org" => "npr.org"
    }.fetch(last_post.domain, last_post.domain)
  end

  def favicon_url
    return unless domain

    "https://icon.horse/icon/#{domain}".html_safe # rubocop:disable Rails/OutputSafety
  end
end

# == Schema Information
#
# Table name: feeds
#
#  id         :bigint           not null, primary key
#  fetched_at :datetime
#  name       :string
#  token      :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_feeds_on_fetched_at  (fetched_at)
#  index_feeds_on_token       (token) UNIQUE
#
