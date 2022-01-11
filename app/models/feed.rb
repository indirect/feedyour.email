class Feed < ApplicationRecord
  has_many :posts
  has_secure_token :token

  nilify_blanks
end
