require "rails_helper"

RSpec.describe "feeds/show.atom", type: :view do
  before do
    @feed = Feed.create!(token: "abc123", name: "somename", domain: "example.com")
    @feed.posts.create!(token: "post", payload: {
      subject: "post title",
      raw_html: "<h1>post!</h1>",
      from: {name: "Adora", email: "adora@princess.alliance"}
    })
    assign :feed, @feed
  end

  it "renders" do
    render

    assert_select "feed" do
      assert_select "title", "somename"
      assert_select "icon", "https://www.google.com/s2/favicons?domain=example.com"
      assert_select "entry" do
        assert_select "title", "post title"
        assert_select "content[type=html]", "<h1>post!</h1>"
        assert_select "author" do
          assert_select "name", "Adora"
          assert_select "email", "adora@princess.alliance"
        end
      end
    end
  end
end
