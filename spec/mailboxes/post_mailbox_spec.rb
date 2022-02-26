require "rails_helper"

RSpec.describe PostMailbox, type: :mailbox do
  fixtures :all
  let(:feed) { feeds(:one) }

  it "creates a post from a full email sample" do
    mail = Mail.from_source Rails.root.join("spec/fixtures/files/money_stuff.eml").read
    expect { process(mail) }.to change { feed.posts.count }
  end

  it "creates a post and saves the mail parts" do
    mail = Mail.new do
      to "abc123@feedyour.email"
      from "adora@princess.alliance"
      subject "an email"

      text_part do
        body "text body"
      end

      html_part do
        body "<p>html body</p>"
      end
    end

    expect { process(mail) }.to change { feed.posts.count }
  end

  it "silently accepts postmark tests" do
    mail = Mail.new(
      from: "support@postmarkapp.com",
      to: "mailbox+SampleHash@inbound.postmarkapp.com"
    )

    expect { process(mail) }.to_not change { feed.posts.count }
  end
end
