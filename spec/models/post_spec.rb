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

  it "has a from" do
    post.update! from: "Alice Example <alice@example.com>"
    address = Mail::Address.new("Alice Example <alice@example.com>")
    expect(post.reload.from).to eq(address)
  end

  it "has a subject" do
    post.subject = "some subject, huh"
    expect(post.subject).to eq("some subject, huh")
  end

  it "has an html_body" do
    post.html_body = "<h1>hi</h1>"
    expect(post.html_body).to eq("<h1>hi</h1>")
  end

  it "has a text_body" do
    post.text_body = "plaintext hi"
    expect(post.text_body).to eq("plaintext hi")
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
