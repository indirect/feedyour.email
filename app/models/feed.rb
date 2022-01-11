class Feed < ApplicationRecord
  has_many :posts
  has_secure_token :token
  nilify_blanks

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length)
  end

  def to_param
    token
  end

end
