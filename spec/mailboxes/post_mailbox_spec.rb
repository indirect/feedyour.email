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

  it "finds the feed email when it's only in Received" do
    mail = Mail.new(
      from: "support@postmarkapp.com",
      to: "postmarkapp@numist.net"
    )
    mail[:received] = <<-HEADER
      from forward3-smtp.messagingengine.com (forward3-smtp.messagingengine.com [66.111.4.237])
      (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
      (No client certificate requested)
      by p-pm-inbound02c-aws-useast1c.inbound.postmarkapp.com (Postfix) with ESMTPS id BCF3C445A82
      for <abc123@feedyour.email>; Mon, 14 Mar 2022 20:51:20 +0000 (UTC)"
    HEADER

    expect { process(mail) }.to change { feed.posts.count }
  end

  it "errors when multiple feed emails are in Received" do
    mail = Mail.new(
      from: "support@postmarkapp.com",
      to: "postmarkapp@numist.net"
    )
    mail[:received] = <<-HEADER
      from forward3-smtp.messagingengine.com (forward3-smtp.messagingengine.com [66.111.4.237])
      (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
      (No client certificate requested)
      by p-pm-inbound02c-aws-useast1c.inbound.postmarkapp.com (Postfix) with ESMTPS id BCF3C445A82
      for <abc123@feedyour.email>; Mon, 14 Mar 2022 20:51:20 +0000 (UTC)"
    HEADER
    mail[:received] = <<-HEADER
      from forward3-smtp.messagingengine.com (forward3-smtp.messagingengine.com [66.111.4.237])
      (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
      (No client certificate requested)
      by p-pm-inbound02c-aws-useast1c.inbound.postmarkapp.com (Postfix) with ESMTPS id BCF3C445A82
      for <def456@feedyour.email>; Mon, 14 Mar 2022 20:51:20 +0000 (UTC)"
    HEADER

    expect {
      expect {
        process(mail)
      }.to raise_error('Too many feeds! ["abc123", "def456"]')
    }.to_not change { feed.posts.count }
  end
end
