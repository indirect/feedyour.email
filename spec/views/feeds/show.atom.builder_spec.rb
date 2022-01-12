require 'rails_helper'

RSpec.describe "feeds/show.atom.builder", type: :view do
  before(:each) do
    @feed = assign(:feed, Feed.create!())
  end

  it "renders" do
    render
  end
end
