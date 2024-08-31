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
    expect(feed).to_not be_expired
    expect { feed.save! }.to change { feed.created_at }
    expect(feed).to_not be_expired
  end

  it "is expired when not fetched for over a year" do
    feed.fetched_at = 2.years.ago
    expect(feed).to be_expired
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
end

# == Schema Information
#
# Table name: feeds
#
#  id           :integer          not null, primary key
#  fetched_at   :datetime
#  name         :string
#  throttled_at :datetime
#  token        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_feeds_on_fetched_at  (fetched_at)
#  index_feeds_on_token       (token) UNIQUE
#
