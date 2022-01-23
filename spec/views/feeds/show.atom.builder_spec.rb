require "rails_helper"

RSpec.describe "feeds/show.atom", type: :view do
  before do
    @feed = Feed.create!(token: "abc123", name: "somename")
    @feed.posts.create!(token: "post", payload: {
      subject: "post title",
      raw_html: "<h1>post!</h1>",
      from: {
        name: "Adora",
        email: "adora@princess.alliance",
        host: "princess.alliance"
      }
    })
    assign :feed, @feed
  end

  it "renders" do
    render

    assert_select "feed" do
      assert_select "title", "somename"
      assert_select "icon", "https://t0.gstatic.com/faviconV2?client=SOCIAL&fallback_opts=TYPE%2CSIZE%2CURL&size=48&type=FAVICON&url=https%3A%2F%2Fprincess.alliance"
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
