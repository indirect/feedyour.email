require 'rails_helper'

RSpec.describe "feeds/index", type: :view do
  before(:each) do
    assign(:feeds, [
      Feed.create!(),
      Feed.create!()
    ])
  end

  it "renders a list of feeds" do
    render
  end
end
