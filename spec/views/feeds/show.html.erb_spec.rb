require "rails_helper"

RSpec.describe "feeds/show", type: :view do
  before do
    @feed = Feed.create!(token: "abc123", name: "somename")
    @feed.posts.create!(token: "post", payload: {
      subject: "post title",
      raw_html: "<h1>post!</h1>",
      from: {name: "Adora", email: "adora@princess.alliance"}
    })
    assign :feed, @feed
  end

  it "renders attributes in <p>" do
    render

    assert_select "code", "abc123@test.host"
    assert_select "code", "http://abc123.test.host/feed.atom"
    assert_select "a[href$='abc123.test.host/posts']"
  end
end
