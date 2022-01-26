require "rails_helper"

RSpec.describe "feeds/show.json", type: :view do
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
    assert_json(render) do
      has :title, "somename"
      has :home_page_url, "http://test.host/feeds/abc123/posts"
      has :icon, "https://icon.horse/icon/princess.alliance"
      has :items do
        item 0 do
          has :id, "post"
          has :url, "http://test.host/posts/post"
          has :title, "post title"
          has :date_published
          has :author do
            has :name, "Adora"
            has :url, "mailto:adora@princess.alliance"
            has :avatar, "https://icon.horse/icon/princess.alliance"
          end
        end
      end
    end
  end
end
