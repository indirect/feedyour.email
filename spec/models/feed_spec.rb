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

    feed.token = "somefeed"
    expect { feed.save! }.to raise_error(ActiveRecord::RecordNotUnique)

    feed.name = "SomeFeed"
    expect { feed.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "uses the token in a fallback name" do
    feed.token = "abc123"
    expect(feed.name).to eq("Feed Your Email abc123")
    feed.name = "somename"
    expect(feed.name).to eq("somename")
  end
end
