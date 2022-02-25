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
    expect(post.token).to be_nil
    expect { post.save! }.to change { post.token }
  end

  it "enforces uniqueness on tokens" do
    conflicting_post = Post.new(feed: Feed.new)
    conflicting_post.token = "somepost"
    conflicting_post.save!

    expect { post.update!(token: "somepost") }.to raise_error(ActiveRecord::RecordNotUnique)
    expect { post.update!(token: "SomePost") }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "has a from_full" do
    post.payload = {"from" => {"full" => "person"}}
    expect(post.from_full).to eq("person")
  end

  it "has a from_name" do
    post.payload = {"from" => {"name" => "person"}}
    expect(post.from_name).to eq("person")
  end

  it "has a from_email" do
    post.payload = {"from" => {"email" => "person"}}
    expect(post.from_email).to eq("person")
  end

  it "has a subject" do
    post.payload = {"subject" => "some subject, huh"}
    expect(post.subject).to eq("some subject, huh")
  end

  it "has html" do
    post.payload = {"raw_html" => "<h1>hi</h1>"}
    expect(post.html).to eq("<h1>hi</h1>")
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  from       :string
#  html_body  :string
#  payload    :jsonb
#  subject    :string
#  text_body  :string
#  token      :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed_id    :bigint
#
# Indexes
#
#  index_posts_on_feed_id                 (feed_id)
#  index_posts_on_feed_id_and_updated_at  (feed_id,updated_at DESC)
#  index_posts_on_token                   (token) UNIQUE
#
