class ExtractPostData < ActiveRecord::Migration[7.0]
  class Post < ApplicationRecord; end

  def change
    Post.where.not(payload: nil).find_each do |post|
      from = post.payload.dig("from", "full")
      post.update!(
        from: Mail::Address.wrap(from),
        subject: post.payload["subject"],
        html_body: post.payload["raw_html"],
        text_body: post.payload["raw_text"]
      )
    end
  end
end
