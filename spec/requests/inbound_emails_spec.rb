require "rails_helper"

RSpec::Matchers.matcher :accept_email do
  match do |actual|
    expect { actual.call }.to change { ActionMailbox::InboundEmail.count }.by(1)
    expect(response).to be_successful
  end
  supports_block_expectations
end

RSpec::Matchers.matcher :reject_email do
  match do |actual|
    expect { actual.call }.to change { ActionMailbox::InboundEmail.count }.by(0)
    expect(response).to be_forbidden
  end
  supports_block_expectations
end

RSpec::Matchers.matcher :create_post do
  match do |actual|
    expect { actual.call }.to change { ActionMailbox::InboundEmail.last }
    expect { ActionMailbox::InboundEmail.last.route }.to change { Post.count }.by(1)
  end
  supports_block_expectations
end
RSpec::Matchers.define_negated_matcher :reject_post, :create_post

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
  end

  def creds(*args)
    ActionController::HttpAuthentication::Basic.encode_credentials(*args)
  end

  describe "POST one email" do
    it "saves the inbound email" do
      expect { post_email }.to accept_email.and create_post
    end

    context "when feed is expired" do
      it "rejects the email" do
        feed.update!(fetched_at: 4.months.ago)

        expect { post_email }.to reject_email
      end
    end
  end

  describe "POST too many emails" do
    context "on day one" do
      it "accepts all emails without warnings" do
        # Regular incoming email
        expect { post_email("llvm-01") }.to accept_email.and create_post

        # Would generate a usage warning (but doesn't on day 1)
        expect { post_email("llvm-02") }.to accept_email.and create_post

        # Would be weekly limit (but isn't on day 1)
        expect { post_email("llvm-03") }.to accept_email.and create_post

        # Past weekly limit (but isn't on day 1)
        expect { post_email("llvm-04") }.to accept_email.and create_post
      end
    end
  end

  context "on day two" do
    it "warns then throttles" do
      feed.update!(created_at: 2.days.ago)

      # Regular incoming email, turn it into a Post when routed
      expect { post_email("llvm-01") }.to change { ActionMailbox::InboundEmail.count }.by(1)
        .and change { feed.posts.count }.by(0)
      expect(response).to be_successful
      expect { ActionMailbox::InboundEmail.last.route }.to change { feed.posts.count }.by(1)

      # Generate a usage warning Post (as well as the incoming email Post)
      expect { post_email("llvm-02") }.to change { ActionMailbox::InboundEmail.count }.by(1)
        .and change { feed.posts.count }.by(0)
      expect(response).to be_successful
      expect { ActionMailbox::InboundEmail.last.route }.to change { feed.posts.count }.by(2)

      # Generate a weekly limit message and reject the incoming email
      expect { post_email("llvm-03") }.to change { ActionMailbox::InboundEmail.count }.by(0)
        .and change { feed.posts.count }.by(1)
      expect(response).to be_forbidden

      # Reject all email beyond the weekly limit
      expect { post_email("llvm-04") }.to change { ActionMailbox::InboundEmail.count }.by(0)
        .and change { feed.posts.count }.by(0)
      expect(response).to be_forbidden
    end
  end
end
