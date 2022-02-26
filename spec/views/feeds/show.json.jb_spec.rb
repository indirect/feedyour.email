require "rails_helper"

RSpec.describe "feeds/show.json", type: :view do
  fixtures :all
  let(:post) { posts(:one) }

  before do
    assign :feed, feeds(:one)
  end

  it "renders" do
    assert_json(render) do
      has :title, "somefeed"
      has :home_page_url, "http://test.host/feeds/abc123/posts"
      has :icon, "https://icon.horse/icon/princess.alliance"
      has :items do
        item 0 do
          has :id, "post_token"
          has :url, "http://test.host/posts/post_token"
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
