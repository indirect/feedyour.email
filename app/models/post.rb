class Post < ApplicationRecord
  belongs_to :feed
  has_secure_token :token

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length)
  end

  def title
    payload["subject"]
  end

  def html
    payload["raw_html"]
  end

  def to_param
    token
  end

end
