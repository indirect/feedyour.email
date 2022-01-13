require "rails_helper"

RSpec.describe FeedsController, type: :routing do
  describe "routing" do
    it "routes the root to feeds#new" do
      expect(get: "/").to route_to("feeds#new")
    end

    it "routes to #new" do
      expect(get: "/feeds/new").to route_to("feeds#new")
    end

    it "routes to #show" do
      expect(get: "/feeds/1").to route_to("feeds#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/feeds").to route_to("feeds#create")
    end
  end
end
