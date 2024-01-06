class Post < ApplicationRecord
  belongs_to :feed
  has_secure_token :token
  serialize :from, type: Mail::Address
  serialize :compressed_html_body, coder: BrotliSerializer
  serialize :compressed_text_body, coder: BrotliSerializer
  delegate :domain, to: :from

  validates :token, uniqueness: {case_sensitive: false}

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length).downcase
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

  def text_body
    self[:compressed_text_body] || self[:text_body]
  end

  def html_body
    @html_body = BodyFormatter.new(
      self[:compressed_html_body] || self[:html_body]
    ).format(from_name)
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
#  id                   :integer          not null, primary key
#  compressed_html_body :binary
#  compressed_text_body :binary
#  from                 :string
#  html_body            :string
#  payload              :json
#  subject              :string
#  text_body            :string
#  token                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  feed_id              :integer
#
# Indexes
#
#  index_posts_on_feed_id                 (feed_id)
#  index_posts_on_feed_id_and_updated_at  (feed_id,updated_at DESC)
#  index_posts_on_token                   (token) UNIQUE
#
