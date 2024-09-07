require "rails_helper"

RSpec.describe "/rails/action_mailbox/postmark/inbound_emails", type: :request do
  let!(:feed) { Feed.create!(token: "v01sntumrlbl20r0yrl6vcsj") }

  def post_email(name = "llvm-01")
    post "/rails/action_mailbox/postmark/inbound_emails", as: :json,
      params: {
        RawEmail: file_fixture("#{name}.eml").read,
        OriginalRecipient: "v01sntumrlbl20r0yrl6vcsj@feedyour.email"
      },
      headers: {
        HTTP_AUTHORIZATION: creds("actionmailbox", "abc123"),
        CONTENT_TYPE: "application/json"
      }
    ActionMailbox::InboundEmail.last&.route
  end

  def creds(*args)
    ActionController::HttpAuthentication::Basic.encode_credentials(*args)
  end

  describe "POST one email" do
    it "saves the inbound email" do
      expect { post_email }.to change { ActionMailbox::InboundEmail.count }.by(1)
      expect(response).to be_successful
    end

    context "when feed is expired" do
      before do
        feed.update!(fetched_at: 4.months.ago)
      end

      it "rejects the email" do
        expect { post_email }.to change { ActionMailbox::InboundEmail.count }.by(0)
        expect(response).to be_forbidden
      end
    end
  end

  describe "POST too many emails" do
    context "on day one" do
      it "is fine" do
        expect { post_email("llvm-01") }.to change { ActionMailbox::InboundEmail.count }.by(1)
        expect(response).to be_successful

        expect { post_email("llvm-02") }.to change { ActionMailbox::InboundEmail.count }.by(1)
        expect(response).to be_successful
      end
    end
  end

  context "on day two" do
    before do
      feed.update!(created_at: 2.days.ago)
    end

    it "throttles and rejects emails" do
      expect { post_email("llvm-01") }.to change { ActionMailbox::InboundEmail.count }.by(1)
        .and change { feed.posts.count }.by(1)
      expect(response).to be_successful

      expect { post_email("llvm-02") }.to change { ActionMailbox::InboundEmail.count }.by(0)
      expect(response).to be_forbidden

      expect { post_email("llvm-03") }.to change { ActionMailbox::InboundEmail.count }.by(0)
      expect(response).to be_forbidden
    end
  end
end
