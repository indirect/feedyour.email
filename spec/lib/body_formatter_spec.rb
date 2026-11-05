require "rails_helper"

RSpec.describe BodyFormatter do
  let(:new_layout) { Rails.root.join("spec/fixtures/files/money_stuff_2026-11-03.html").read }
  let(:old_layout) { Rails.root.join("spec/fixtures/files/money_stuff_2022.html").read }

  it "formats emails from the new Bloomberg sender name" do
    body = described_class.new(new_layout).format("Matt Levine at Bloomberg Opinion")

    expect(body).to include("newsfoot")
    expect(body).to include('href="#footnote-1" class="footnote-index"')
    expect(body).to include('id="footnote-1" class="footnote-content"')
  end

  it "still formats emails from the old sender name" do
    body = described_class.new(new_layout).format("Matt Levine")

    expect(body).to include("newsfoot")
    expect(body).to include('href="#footnote-1" class="footnote-index"')
  end

  it "hides liveintent ads in the new layout" do
    body = described_class.new(new_layout).format("Matt Levine at Bloomberg Opinion")

    expect(body).to include("[class^=\"liveintent\"]")
    expect(body).to include(".mq-lihide")
    expect(body).to include(".mq-lishow")
    expect(body).to include("img[src*=\"sli.bloomberg.com\"]")
  end

  it "hides the election banner and podcast promo in the new layout" do
    body = described_class.new(new_layout).format("Matt Levine at Bloomberg Opinion")

    expect(body).to include("figure a img[alt]:not([alt=\"\"])")
    expect(body).to include("a[title*=\"Podcast\"] figure")
  end

  it "leaves other senders alone" do
    body = described_class.new(new_layout).format("Some One Else")

    expect(body).to eq(new_layout)
  end

  it "still formats the 2022 email layout" do
    body = described_class.new(old_layout).format("Matt Levine")

    expect(body).not_to start_with("<!DOCTYPE")
    expect(body).to include("newsfoot")
    expect(body).to include("[class^=\"liveintent\"]")
    expect(body).not_to include("<table class=\"footer\"")
  end
end
