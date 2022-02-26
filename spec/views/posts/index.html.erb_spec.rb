require "rails_helper"

RSpec.describe "posts/index", type: :view do
  fixtures :all

  let(:post) { posts(:one) }

  before do
    assign :feed, feeds(:one)
    assign :posts, post
  end

  it "renders a list of posts" do
    render

    assert_select "a[href='/posts/post_token']" do
      assert_select "p", "post title"
      assert_select "p", "Adora <adora@princess.alliance>"
      assert_select "time", /#{post.updated_at.to_date.to_formatted_s(:short)}/
    end
  end
end
