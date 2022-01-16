class Feed < ApplicationRecord
  has_many :posts, -> { order(updated_at: :desc) },
    dependent: :destroy, inverse_of: :feed
  has_secure_token :token
  nilify_blanks

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length)
  end

  def name
    read_attribute(:name) || 'Feed Your Email #{token}' if token
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

  def favicon_url
    return unless domain

    URI("https://www.google.com/s2/favicons").tap do |u|
      u.query = "domain=#{domain}"
    end.to_s
  end
end
