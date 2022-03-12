require "rails_helper"
require_relative "../support/validate_json_feed"
require_relative "../support/validate_atom_feed"

RSpec.describe "/feeds", type: :request do
  include ValidateJsonFeed
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
        validate_atom_feed
      end
    end

    context "with a post" do
      fixtures :all
      let(:feed) { feeds(:one) }

      it "is valid according to RNG" do
        expect {
          get feed_url(feed, format: :atom)
        }.to change { feed.reload.fetched_at }
        validate_atom_feed
      end
    end
  end

  describe "GET /show.json" do
    context "without a post" do
      it "is valid by the JSON Feed schema" do
        get feed_url(feed, format: :json)
        expect(validate_json_feed).to eq([])
      end
    end

    context "with a post" do
      fixtures :all
      let(:feed) { feeds(:one) }

      it "is valid by the JSON Feed schema" do
        expect {
          get feed_url(feed, format: :json)
        }.to change { feed.reload.fetched_at }
        expect(validate_json_feed).to eq([])
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
