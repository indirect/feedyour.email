class Feed < ApplicationRecord
  has_many :posts, -> { order(updated_at: :desc) },
    dependent: :destroy, inverse_of: :feed
  has_many :week_posts, -> { last_week.not_system.order(updated_at: :desc) },
    class_name: "Post", dependent: nil, inverse_of: :feed
  has_one :last_post, -> { order(updated_at: :desc) },
    class_name: "Post", dependent: nil, inverse_of: :feed
  has_secure_token :token

  validates :token, uniqueness: {case_sensitive: false}
  nilify_blanks

  after_commit :post_welcome, on: :create
  after_commit :post_warnings, on: :update

  scope :expired, -> { where.not(expired_at: nil) }
  scope :stale, -> { where("updated_at < ?", config.stale_months.months.ago) }
  scope :throttled, -> { where.not(throttled_at: nil) }
  scope :unthrottleable, -> { where("throttled_at < ?", config.throttle_days.days.ago) }

  def self.config
    Rails.application.config.x.feed
  end

  def self.generate_unique_secure_token(length:)
    SecureRandom.base36(length).downcase
  end

  def name
    read_attribute(:name) || "Feed #{token[0..2]}#{token[-3..]}" if token
  end

  def to_param
    token
  end

  def fetched_at
    read_attribute(:fetched_at) || created_at
  end

  def domain
    return unless last_post
    return last_post.from_email.tr("@", ".") if last_post.domain == "substack.com"

    {
      "mail.bloombergview.com" => "bloomberg.com",
      "nl.npr.org" => "npr.org",
      "feedyour.email" => nil
    }.fetch(last_post.domain, last_post.domain)
  end

  def favicon_url
    return unless domain

    "https://icon.horse/icon/#{domain}".html_safe # rubocop:disable Rails/OutputSafety
  end

  def throttle!
    update!(throttled_at: Time.now.utc) unless throttled_at?
  end

  def unthrottle!
    if week_posts.count < config.week_limit
      update!(throttled_at: nil, warned_at: nil)
    end
  end

  def warn_if_needed
    return if 1.day.ago < created_at || warned_at?

    if week_posts.count == config.warn_limit
      touch(:warned_at)
      create_post("warning", "Feed usage warning")
    end
  end

  def fetch_or_expire!
    return if expired_at

    save! if new_record?
    stale? ? touch(:expired_at) : touch(:fetched_at)
  end

  def expire_if_stale!
    save! if new_record?
    touch(:expired_at) if stale?
  end

  def stale?
    # feed has not been fetched in the last 3 months
    Time.current.after? fetched_at.advance(months: 3)
  end

  private

  def config
    self.class.config
  end

  def post_welcome
    create_post("welcome", "Welcome to Feed Your Email!")
  end

  def post_warnings
    if expired_at_previously_changed?(from: nil)
      create_post("expired", "Feed expired due to inactivity")
    end

    if throttled_at_previously_changed?(from: nil)
      create_post("throttled", "Feed usage limit reached")
    end
  end

  def create_post(name, subject)
    posts.create!(
      from: Rails.configuration.system_email,
      subject: subject,
      html_body: ApplicationController.render(
        ["posts/template", name].join("/"),
        layout: "post_template",
        assigns: {feed: self, subject: subject}
      )
    )
  end
end

# == Schema Information
#
# Table name: feeds
#
#  id           :integer          not null, primary key
#  expired_at   :datetime
#  fetched_at   :datetime
#  name         :string
#  throttled_at :datetime
#  token        :string           not null
#  warned_at    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_feeds_on_fetched_at  (fetched_at)
#  index_feeds_on_token       (token) UNIQUE
#
