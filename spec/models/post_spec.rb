require "rails_helper"

RSpec.describe Post, type: :model do
  subject(:post) { Post.new(feed: Feed.new) }

  it "has a feed" do
    expect(post.feed).to be_a(Feed)
  end

  it "requires a feed" do
    post.feed = nil
    post.valid?
    expect(post.errors[:feed]).to eq(["must exist"])
  end

  it "generates a token" do
    expect(post.token).to eq(nil)
    expect { post.save! }.to change { post.token }
  end

  it "enforces uniqueness on tokens" do
    conflicting_post = Post.new(feed: Feed.new)
    conflicting_post.token = "somepost"
    conflicting_post.save!

    post.token = "somepost"
    expect { post.save! }.to raise_error(ActiveRecord::RecordNotUnique)

    post.token = "SomePost"
    expect { post.save! }.to raise_error(ActiveRecord::RecordNotUnique)
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
