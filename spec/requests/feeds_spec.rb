require "rails_helper"

RSpec.describe "/feeds", type: :request do
  let(:valid_attributes) { {token: "somefeed"} }
  let(:feed) { Feed.create! valid_attributes }

  describe "GET /show" do
    it "renders a successful response" do
      get feed_url(feed)
      expect(response).to be_successful
    end
  end

  describe "GET .atom" do
    require "support/assert_valid_feed"
    include W3C::FeedValidator::Assertions

    context "without a post" do
      it "is valid according to W3C" do
        get feed_url(feed, format: :atom)
        assert_valid_feed
      end
    end

    context "with a post" do
      it "is valid according to W3C" do
        payload = Rails.root.join("spec/support/body.json").read
        expect {
          EmailProcessor.for_payload(payload).process
        }.to change { feed.posts.count }
        get feed_url(feed, format: :atom)
        assert_valid_feed
      end
    end

    it "updates last_fetched_at" do
      feed.last_fetched_at = 2.years.ago
      expect(feed.expired?).to be_truthy
      get feed_url(feed, format: :atom)
      feed.reload
      expect(feed.expired?).to be_falsey
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_feed_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with a feed name" do
      it "creates a new Feed" do
        expect {
          post feeds_url, params: {feed: {name: "some feed"}}
        }.to change(Feed, :count).by(1)
        expect(response).to redirect_to(feed_url(Feed.last))
      end
    end

    context "without a feed name" do
      it "creates a new Feed" do
        expect { post feeds_url }.to change(Feed, :count).by(1)
        expect(response).to redirect_to(feed_url(Feed.last))
      end
    end
  end
end
