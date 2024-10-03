# frozen_string_literal: true

class DecompressPlaintext < ActiveRecord::Migration[7.2]
  def up
    Post.find_each do |post|
      post[:text_body] = post[:compressed_text_body]
      post[:compressed_text_body] = nil
      post.save!
    end
  end

  def down
    Post.find_each do |post|
      post[:compressed_text_body] = post[:text_body]
      post[:text_body] = nil
      post.save!
    end
  end
end
