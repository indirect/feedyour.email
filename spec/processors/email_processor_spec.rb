require "rails_helper"

RSpec.describe EmailProcessor, type: :processor do
  subject(:processor) { EmailProcessor.new(payload: payload) }

  let(:payload) { Rails.root.join("spec/support/body.json").read }

  it "creates a post on the feed" do
    feed = Feed.create!(token: "somefeed")
    expect { processor.process }.to change { feed.reload.posts }
  end
end
