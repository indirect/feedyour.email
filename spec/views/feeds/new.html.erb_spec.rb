require 'rails_helper'

RSpec.describe "feeds/new", type: :view do
  before(:each) do
    assign(:feed, Feed.new())
  end

  it "renders new feed form" do
    render

    assert_select "form[action=?][method=?]", feeds_path, "post" do
    end
  end
end
