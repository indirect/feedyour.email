require 'rails_helper'

RSpec.describe "feeds/show", type: :view do
  before(:each) do
    @feed = assign(:feed, Feed.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
