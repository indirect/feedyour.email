class Post < ApplicationRecord
  belongs_to :feed

  validates :token, uniqueness: {case_sensitive: false}

  before_save :ensure_searchable!
  after_commit -> { feed.warn_if_needed unless system? }

  scope :last_hour, -> { where("created_at > ?", 1.hour.ago) }
  scope :last_week, -> { where("created_at > ?", 1.week.ago) }
  scope :not_system, -> { where.not(from: Rails.configuration.system_email) }
  scope :system, -> { where(from: Rails.configuration.system_email) }

  include Litesearch::Model

  def self.search(term)
    super(term.tr("'", " "))
  end

  litesearch do |schema|
    schema.field :text_body
    schema.field :subject
    schema.field :raw_from
  end

  serialize :from, type: Mail::Address
  serialize :compressed_html_body, coder: BrotliSerializer
  serialize :compressed_text_body, coder: BrotliSerializer

  has_secure_token :token

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length).downcase
  end

  delegate :domain, to: :from

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

  def system?
    from_email == "system@feedyour.email"
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

  def ensure_searchable!
    self.raw_from ||= from.format if respond_to?(:raw_from)
    self.text_body ||= html_body_as_plain_text
  end

  def html_body_as_plain_text
    node = Nokogiri::HTML5(html_body, max_tree_depth: 1000)
    ActionText::PlainTextConversion.node_to_plain_text(node)
  rescue ArgumentError => e
    "Error parsing HTML: #{e.message}"
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
#  raw_from             :string
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
