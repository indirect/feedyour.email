require "rails_helper"

RSpec.describe "feeds/show", type: :view do
  fixtures :all
  let(:feed) { feeds(:one) }

  before { assign :feed, feed }

  it "renders attributes in <p>" do
    render

    assert_select "code", "abc123@test.host"
    assert_select "code", "http://test.host/feeds/abc123.atom"
    assert_select "a[href~='/feeds/abc123/posts']"
  end
end
