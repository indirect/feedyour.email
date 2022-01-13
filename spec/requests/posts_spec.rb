require "rails_helper"

RSpec.describe "/posts", type: :request do
  let(:feed) { Feed.create! }
  let(:valid_attributes) {
    {
      feed: feed,
      payload: {
        from: {
          full: "Adora <adora@princess.alliance>",
          name: "Adora",
          email: "adora@princess.alliance"
        },
        subject: "post subject",
        raw_html: "<h1>post!</>"
      }
    }
  }

  let(:invalid_attributes) {}

  describe "GET /index" do
    it "renders a successful response" do
      Post.create! valid_attributes
      get feed_posts_url(feed)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      post = Post.create! valid_attributes
      get post_url(post)
      expect(response).to be_successful
    end
  end
end
