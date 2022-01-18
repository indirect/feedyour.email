class PostsController < ApplicationController
  def index
    @feed = Feed.find_by!(token: params[:feed_id])
    @posts = @feed.posts
  end

  def show
    @post = Post.find_by!(token: params[:id])

    # rubocop:disable Rails/OutputSafety
    render html: @post.payload["raw_html"].html_safe
    # rubocop:enable Rails/OutputSafety
  end
end
