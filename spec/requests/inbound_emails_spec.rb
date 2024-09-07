require "rails_helper"

RSpec.describe "/rails/action_mailbox/postmark/inbound_emails", type: :request do
  let!(:feed) { Feed.create!(token: "v01sntumrlbl20r0yrl6vcsj") }

  let(:auth) {
    {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials("actionmailbox", "abc123"),
      CONTENT_TYPE: "application/json"
    }
  }

  describe "POST one email" do
    let(:payload) do
      {
        RawEmail: file_fixture("llvm-01.eml").read,
        OriginalRecipient: "v01sntumrlbl20r0yrl6vcsj@feedyour.email"
      }
    end

    it "saves the inbound email" do
      expect {
        post "/rails/action_mailbox/postmark/inbound_emails",
          params: payload, headers: auth, as: :json
      }.to change { ActionMailbox::InboundEmail.count }.by(1)

      expect(response).to be_successful
    end

    context "when feed is expired" do
      before do
        feed.update!(fetched_at: 4.months.ago)
      end

      it "rejects the email" do
        expect {
          post "/rails/action_mailbox/postmark/inbound_emails",
            params: payload, headers: auth, as: :json
        }.to change { ActionMailbox::InboundEmail.count }.by(0)

        expect(response).to be_forbidden
      end
    end
  end

  describe "POST too many emails" do
    context "on day one" do
      it "is fine" do
        (1..14).each do |i|
          payload = {
            RawEmail: file_fixture("llvm-#{sprintf("%02d", i)}.eml").read,
            OriginalRecipient: "v01sntumrlbl20r0yrl6vcsj@feedyour.email"
          }

          expect {
            post "/rails/action_mailbox/postmark/inbound_emails",
              params: payload, headers: auth, as: :json
          }.to change { ActionMailbox::InboundEmail.count }.by(1)
          expect(response).to be_successful
          ActionMailbox::InboundEmail.last.route
        end
      end
    end

    context "on day two" do
      before do
        feed.update!(created_at: 2.days.ago)
      end

      it "throttles and rejects emails" do
        (1..14).each do |i|
          payload = {
            RawEmail: file_fixture("llvm-#{sprintf("%02d", i)}.eml").read,
            OriginalRecipient: "v01sntumrlbl20r0yrl6vcsj@feedyour.email"
          }

          expect {
            post "/rails/action_mailbox/postmark/inbound_emails",
              params: payload, headers: auth, as: :json
          }.to change { ActionMailbox::InboundEmail.count }.by(1), "email #{i} not created"
          expect(response).to be_successful, "webhook #{i} failed"
          ActionMailbox::InboundEmail.last.route
        end

        payload = {
          RawEmail: file_fixture("llvm-15.eml").read,
          OriginalRecipient: "v01sntumrlbl20r0yrl6vcsj@feedyour.email"
        }

        expect {
          post "/rails/action_mailbox/postmark/inbound_emails",
            params: payload, headers: auth, as: :json
        }.to_not change { ActionMailbox::InboundEmail.count }
        expect(response).to be_forbidden
      end
    end
  end
end
