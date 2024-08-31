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
    it "saves the inbound email" do
      payload = {
        RawEmail: file_fixture("llvm-01.eml").read,
        OriginalRecipient: "v01sntumrlbl20r0yrl6vcsj@feedyour.email"
      }

      expect {
        post "/rails/action_mailbox/postmark/inbound_emails",
          params: payload, headers: auth, as: :json
      }.to change { ActionMailbox::InboundEmail.count }.by(1)

      expect(response).to be_successful
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
          }.to change { ActionMailbox::InboundEmail.count }.by(1)
          expect(response).to be_successful
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
