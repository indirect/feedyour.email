class Feed < ApplicationRecord
  has_many :posts, -> { order(updated_at: :desc) }
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

end
