require "rails_helper"

RSpec.describe "feeds/new", type: :view do
  before do
    assign(:feed, Feed.new)
  end

  it "renders new feed form" do
    render

    assert_select "form[action=?][method=?]", feeds_path, "post" do
      assert_select "label[for=feed_name]"
      assert_select "input[name='feed[name]']"
    end
  end
end
