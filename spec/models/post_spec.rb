require "rails_helper"

RSpec.describe Post, type: :model do
  subject(:post) { Post.new(feed: Feed.new) }

  it "has a feed" do
    expect(post.feed).to be_a(Feed)
  end

  it "generates a token" do
    expect(post.token).to eq(nil)
    expect { post.save! }.to change { post.token }
  end

  it "has a from" do
    post.payload = {"from" => {"full" => "person"}}
    expect(post.from).to eq("person")
  end

  it "has a from_name" do
    post.payload = {"from" => {"name" => "person"}}
    expect(post.from_name).to eq("person")
  end

  it "has a from_email" do
    post.payload = {"from" => {"email" => "person"}}
    expect(post.from_email).to eq("person")
  end

  it "has a title" do
    post.payload = {"subject" => "some subject, huh"}
    expect(post.title).to eq("some subject, huh")
  end

  it "has html" do
    post.payload = {"raw_html" => "<h1>hi</h1>"}
    expect(post.html).to eq("<h1>hi</h1>")
  end
end
