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
    expect { ActionMailbox::InboundEmail.last.route }.to change { Post.not_system.count }.by(1)
  end
  supports_block_expectations
end

RSpec::Matchers.matcher :create_warning do
  match do |actual|
    expect { actual.call }.to change { Post.system.count }.by(1)
  end
  supports_block_expectations
end

RSpec::Matchers.matcher :skip_warning do
  match do |actual|
    expect { actual.call }.to change { Post.system.count }.by(0)
  end
  supports_block_expectations
end

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

  context "after day one" do
    it "warns once, then throttles, then warns after unthrottle" do
      feed.update!(created_at: 2.days.ago)

      # Regular incoming email, turn it into a Post when routed
      expect { post_email("llvm-01") }.to accept_email.and create_post

      # Generate a usage warning Post (as well as the incoming email Post)
      expect { post_email("llvm-02") }.to accept_email.and create_post.and create_warning
        .and change { feed.reload.warned_at }.from(nil)

      # Do not warn a second time even when reaching the warn limit
      feed.week_posts.last.destroy # remove post so next post will hit warn limit
      expect { post_email("llvm-03") }.to accept_email.and create_post

      # Generate a weekly limit message and reject the incoming email
      expect { post_email("llvm-04") }.to reject_email.and create_warning
        .and change { feed.reload.throttled_at }.from(nil)

      # Reject all email beyond the weekly limit
      expect { post_email("llvm-05") }.to reject_email.and skip_warning

      # No throttle post a second time if we go under then above the limit
      feed.week_posts.last.destroy # remove post so next post will hit hard limit
      expect { post_email("llvm-06") }.to accept_email.and create_post.and skip_warning

      # No throttle post when rejecting emails a second time
      expect { post_email("llvm-07") }.to reject_email.and skip_warning

      # Hourly job to unthrottle after 3 days, if posts under limit
      feed.update!(throttled_at: 4.days.ago)
      feed.week_posts.last.destroy
      expect(feed.unthrottle!).to eq(true)

      # Next post at the warn limit creates a new warning message
      expect { post_email("llvm-08") }.to accept_email.and create_post.and create_warning
        .and change { feed.reload.warned_at }.from(nil)

      # Next post at the hard limit is rejected and creates throttle message
      expect { post_email("llvm-09") }.to reject_email.and create_warning
        .and change { feed.reload.throttled_at }.from(nil)
    end
  end
end
