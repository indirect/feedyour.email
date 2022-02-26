require "rails_helper"

RSpec.describe "feeds/show.atom", type: :view do
  fixtures :all
  let(:feed) { feeds(:one) }

  before do
    assign :feed, feed
  end

  it "renders" do
    render

    assert_select "feed" do
      assert_select "title", "somefeed"
      assert_select "icon", "https://icon.horse/icon/princess.alliance"
      assert_select "entry" do
        assert_select "title", "post title"
        assert_select "content[type=html]", "<h1>a post!</h1>"
        assert_select "author" do
          assert_select "name", "Adora"
          assert_select "email", "adora@princess.alliance"
        end
      end
    end
  end
end
