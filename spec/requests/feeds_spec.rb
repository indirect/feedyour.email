require "rails_helper"
require "support/validate_feed"

RSpec.describe "/feeds", type: :request do
  include ValidateFeed
  let(:valid_attributes) { {token: "somefeed"} }
  let(:feed) { Feed.create! valid_attributes }

  describe "GET /show" do
    it "renders a successful response" do
      expect {
        get feed_url(feed)
      }.to_not change { feed.reload.fetched_at }

      expect(response).to be_successful
    end
  end

  describe "GET /show.atom" do
    context "without a post" do
      it "is valid according to RNG" do
        get feed_url(feed, format: :atom)
        expect(response.body).to be_valid_atom_feed
      end
    end

    context "with a post" do
      fixtures :all
      let(:feed) { feeds(:one) }

      it "is valid according to RNG" do
        expect {
          get feed_url(feed, format: :atom)
        }.to change { feed.reload.fetched_at }
        expect(response.body).to be_valid_atom_feed
      end

      context "and expired" do
        it "is cached forever" do
          feed.update!(fetched_at: 4.months.ago)

          expect {
            get feed_url(feed, format: :atom)
          }.to_not change { feed.reload.fetched_at }
          expect(response.header["cache-control"]).to eq("max-age=3155695200, public")
          expect(response.body).to be_valid_atom_feed
        end
      end
    end
  end

  describe "GET /show.json" do
    context "without a post" do
      it "is valid by the JSON Feed schema" do
        get feed_url(feed, format: :json)
        expect(response.body).to be_valid_json_feed
      end
    end

    context "with a post" do
      fixtures :all
      let(:feed) { feeds(:one) }

      it "is valid by the JSON Feed schema" do
        expect {
          get feed_url(feed, format: :json)
        }.to change { feed.reload.fetched_at }
        expect(response.body).to be_valid_json_feed
      end

      context "and expired" do
        it "is cached forever" do
          feed.update!(fetched_at: 4.months.ago)

          expect {
            get feed_url(feed, format: :json)
          }.to_not change { feed.reload.fetched_at }
          expect(response.header["cache-control"]).to eq("max-age=3155695200, public")
          expect(response.body).to be_valid_json_feed
        end
      end
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
