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

  it "uses the token in a fallback name" do
    feed.token = "abc123"
    expect(feed.name).to eq("Feed Your Email abc123")
    feed.name = "somename"
    expect(feed.name).to eq("somename")
  end
end
