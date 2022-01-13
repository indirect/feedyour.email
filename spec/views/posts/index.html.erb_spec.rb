require "rails_helper"

RSpec.describe "posts/index", type: :view do
  before do
    @feed = Feed.create!(token: "abc123", name: "somename")
    @post = @feed.posts.create!(token: "ptoken", payload: {
      subject: "post title",
      raw_html: "<h1>post!</h1>",
      from: {full: "Adora <adora@princess.alliance>"}
    })
    assign :feed, @feed
    assign :posts, [@post]
  end

  it "renders a list of posts" do
    render

    assert_select "a[href='/posts/ptoken']" do
      assert_select "p", "post title"
      assert_select "p", "Adora <adora@princess.alliance>"
      assert_select "time", /#{@post.updated_at.to_date.to_formatted_s(:short)}/
    end
  end
end
