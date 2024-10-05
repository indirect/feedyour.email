# frozen_string_literal: true

require "progress_bar"

module Progress
  refine Enumerable do
    define_method :with_progress, ProgressBar::WithProgress.instance_method(:with_progress)
  end
end

class DecompressPlaintext < ActiveRecord::Migration[7.2]
  using Progress

  def up
    Post.where(text_body: nil).where.not(compressed_text_body: nil)
      .find_each.with_progress do |post|
      post[:text_body] ||= post[:compressed_text_body]
      post[:compressed_text_body] = nil if post[:text_body]
      post.save!
    end
  end

  def down
    Post.where(compressed_text_body: nil).where.not(text_body: nil)
      .find_each.with_progress do |post|
      post[:compressed_text_body] ||= post[:text_body]
      post[:text_body] = nil if post[:compressed_text_body]
      post.save!
    end
  end
end
