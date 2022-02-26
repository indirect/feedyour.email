class Post < ApplicationRecord
  belongs_to :feed
  has_secure_token :token
  serialize :from, Mail::Address
  delegate :domain, to: :from

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length)
  end

  def from=(from)
    write_attribute :from, parse_from(from)
  end

  def from_name
    from.display_name
  end

  def from_email
    from.address
  end

  def to_param
    token
  end

  private

  def parse_from(from)
    Mail::Address.wrap(from)
  rescue Mail::Field::IncompleteParseError
    # hacky workaround for improperly quoted names
    from.match(/(.*?) <(.*)>/) do |m|
      Mail::Address.new("\"#{m[1]}\" <#{m[2]}>")
    end
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  from       :string
#  html_body  :string
#  payload    :jsonb
#  subject    :string
#  text_body  :string
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
