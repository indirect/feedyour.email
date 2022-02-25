class Post < ApplicationRecord
  belongs_to :feed
  has_secure_token :token
  store_accessor :payload, :from, :subject, :raw_html

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length)
  end

  def from_full
    payload.dig("from", "full")
  end

  def from_name
    payload.dig("from", "name")
  end

  def from_email
    payload.dig("from", "email")
  end

  def domain
    payload.dig("from", "host")
  end

  def html
    payload["raw_html"]
  end

  def to_param
    token
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  payload    :jsonb
#  token      :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed_id    :bigint
#
# Indexes
#
#  index_posts_on_feed_id                 (feed_id)
#  index_posts_on_feed_id_and_updated_at  (feed_id,updated_at DESC)
#  index_posts_on_token                   (token) UNIQUE
#
