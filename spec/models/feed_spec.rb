require "rails_helper"

RSpec.describe Feed, type: :model do
  subject(:feed) { Feed.new }

  it "has posts" do
    expect(feed.posts).to eq([])
  end

  it "generates a token" do
    expect(feed.token).to eq(nil)
    expect { feed.save! }.to change { feed.token }
  end

  it "enforces uniqueness on tokens" do
    conflicting_feed = Feed.new
    conflicting_feed.token = "somefeed"
    conflicting_feed.save!

    expect { feed.update!(token: "somefeed") }.to raise_error(ActiveRecord::RecordNotUnique)
    expect { feed.update!(token: "SomeFeed") }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "uses the token in a fallback name" do
    feed.token = "abc123"
    expect(feed.name).to eq("Feed Your Email abc123")
    feed.name = "somename"
    expect(feed.name).to eq("somename")
  end

  it "is not expired when new" do
    expect(feed.created_at).to be_nil
    expect(feed.fetched_at).to be_nil
    expect(feed.expired?).to be_falsey
    expect { feed.save! }.to change { feed.created_at }
    expect(feed.expired?).to be_falsey
  end

  it "is expired when not fetched for over a year" do
    feed.fetched_at = 2.years.ago
    expect(feed.expired?).to be_truthy
  end
end
