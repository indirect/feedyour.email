require "rails_helper"

RSpec.describe FeedsController, type: :controller do
  describe "#new" do
    it "succeeds" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "#create" do
    it "suceeds and redirects" do
      post :create, params: {name: "Some name"}
      expect(response).to be_redirect
    end
  end

  describe "#show" do
    before do
      Feed.find_or_create_by!(token: "abc123")
    end

    it "succeeds" do
      get :show, params: {id: "abc123"}
      expect(response).to be_successful
    end

    it "succeeds with json" do
      get :show, params: {id: "abc123"}, format: :json
      expect(response).to be_successful
    end

    it "succeeds with atom" do
      get :show, params: {id: "abc123"}, format: :atom
      expect(response).to be_successful
    end
  end
end
