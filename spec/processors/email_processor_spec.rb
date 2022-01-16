require "rails_helper"

RSpec.describe EmailProcessor, type: :processor do
  subject(:processor) { EmailProcessor.from_payload(payload) }

  let(:payload) { Rails.root.join("spec/support/body.json").read }

  it "updates the feed domain" do
    feed = Feed.create!(token: "somefeed")
    expect { processor.process }.to change { feed.reload.domain }
  end
end
