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
