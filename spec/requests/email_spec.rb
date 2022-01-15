require "rails_helper"

RSpec.describe "/email", type: :request do
  let(:valid_attributes) { {token: "somefeed"} }
  let(:feed) { Feed.create! valid_attributes }

  describe "POST /email/incoming" do
    it "creates a post" do
      expect(feed).to be
      expect {
        payload = Rails.root.join("spec/support/body.json").read
        headers = {"CONTENT_TYPE" => "application/json"}
        post "/email/incoming", params: payload, headers: headers
        expect(response).to be_successful
      }.to change { Post.count }
    end

    context "without a feed" do
      it "does not create a post" do
        expect {
          payload = Rails.root.join("spec/support/body.json").read
          headers = {"CONTENT_TYPE" => "application/json"}
          post "/email/incoming", params: payload, headers: headers
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
