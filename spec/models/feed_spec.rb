require "rails_helper"

RSpec.describe Feed, type: :model do
  subject(:feed) { Feed.new }

  it "has posts" do
    expect(feed.posts).to eq([])
  end

  it "generates a token" do
    expect(feed.token).to be_nil
    expect { feed.save! }.to change { feed.token }
  end

  it "enforces uniqueness on tokens" do
    feed.update!(token: "somefeed")

    expect {
      Feed.create!(token: "somefeed")
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect {
      Feed.create!(token: "SomeFeed")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "uses the token in a fallback name" do
    feed.token = "abc123"
    expect(feed.name).to eq("Feed abc123")
    feed.name = "somename"
    expect(feed.name).to eq("somename")
  end

  it "is not expired when new" do
    expect(feed).to_not be_expired_at
    expect { feed.save! }.to change { feed.created_at }
    feed.expire_if_stale!
    expect(feed).to_not be_expired_at
  end

  it "is expired when not fetched for over 3 months" do
    feed.fetched_at = 4.months.ago
    feed.expire_if_stale!
    expect(feed).to be_expired_at
  end

  describe "domain" do
    it "updates on post arriving" do
      feed.save!
      expect(feed.domain).to eq(nil)
      expect {
        feed.posts.create!(from: "alice@example.com")
      }.to change { feed.reload.domain }
    end

    it "handles substacks" do
      feed.save!
      feed.posts.create!(from: "todayintabs@substack.com")
      expect(feed.domain).to eq("todayintabs.substack.com")
    end
  end

  describe "favicon_url" do
    it "updates on post arriving" do
      feed.save!
      expect(feed.favicon_url).to eq(nil)
      expect {
        feed.posts.create!(from: "alice@example.com")
      }.to change { feed.reload.favicon_url }
    end
  end

  describe "over_week_limit?" do
    context "when not subscribed" do
      before { feed.update!(subscribed_until: nil) }

      it "is true when posts count equals config.week_limit" do
        expect(feed).to_not be_over_week_limit
        while feed.week_posts.count < Feed.config.week_limit
          feed.posts.create!(from: "alice@example.com")
        end
        expect(feed.week_posts.count).to eq(Feed.config.week_limit)
        expect(feed).to be_over_week_limit
      end

      it "is false when posts count is under config.week_limit" do
        expect(feed).to_not be_over_week_limit
        while feed.week_posts.count < (Feed.config.week_limit - 1)
          feed.posts.create!(from: "alice@example.com")
        end
        expect(feed.week_posts.count).to be < Feed.config.week_limit
        expect(feed).to_not be_over_week_limit
      end

      it "is true when posts count is over config.week_limit" do
        expect(feed).to_not be_over_week_limit
        while feed.week_posts.count < (Feed.config.week_limit + 1)
          feed.posts.create!(from: "alice@example.com")
        end
        expect(feed.week_posts.count).to be > Feed.config.week_limit
        expect(feed).to be_over_week_limit
      end
    end

    context "when subscribed" do
      before { feed.update!(subscribed_until: 1.day.from_now) }

      it "is false when posts count equals config.week_limit" do
        expect(feed).to_not be_over_week_limit
        while feed.week_posts.count < Feed.config.week_limit
          feed.posts.create!(from: "alice@example.com")
        end
        expect(feed.week_posts.count).to eq(Feed.config.week_limit)
        expect(feed).to_not be_over_week_limit
      end

      it "is false when posts count is under config.week_limit" do
        expect(feed).to_not be_over_week_limit
        while feed.week_posts.count < (Feed.config.week_limit - 1)
          feed.posts.create!(from: "alice@example.com")
        end
        expect(feed.week_posts.count).to be < Feed.config.week_limit
        expect(feed).to_not be_over_week_limit
      end

      it "is false when posts count is over config.week_limit" do
        expect(feed).to_not be_over_week_limit
        while feed.week_posts.count < (Feed.config.week_limit + 1)
          feed.posts.create!(from: "alice@example.com")
        end
        expect(feed.week_posts.count).to be > Feed.config.week_limit
        expect(feed).to_not be_over_week_limit
      end
    end
  end

  describe "subscribed?" do
    it "is false when subscribed_until is nil" do
      feed.subscribed_until = nil
      expect(feed).to_not be_subscribed
    end

    it "is false when subscribed_until is in the past" do
      feed.subscribed_until = 1.day.ago
      expect(feed).to_not be_subscribed
    end

    it "is true when subscribed_until is in the future" do
      feed.subscribed_until = 1.minute.from_now
      expect(feed).to be_subscribed
    end
  end
end

# == Schema Information
#
# Table name: feeds
#
#  id               :integer          not null, primary key
#  expired_at       :datetime
#  fetched_at       :datetime
#  name             :string
#  subscribed_until :datetime
#  throttled_at     :datetime
#  token            :string           not null
#  warned_at        :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_feeds_on_fetched_at  (fetched_at)
#  index_feeds_on_token       (token) UNIQUE
#
