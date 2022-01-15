class Feed < ApplicationRecord
  has_many :posts, -> { order(updated_at: :desc) },
    dependent: :destroy, inverse_of: :feed
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

  def last_fetched_at
    read_attribute(:last_fetched_at) || created_at
  end

  def expired?
    return false unless last_fetched_at

    Time.current.after? last_fetched_at.next_year
  end
end
