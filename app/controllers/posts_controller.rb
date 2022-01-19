class PostsController < ApplicationController
  def index
    @feed = Feed.find_by!(token: params[:feed_id] || request.subdomain)
    @posts = @feed.posts
  end

  def show
    @post = Post.find_by!(token: params[:id])
    render html: @post.payload["raw_html"].html_safe # rubocop:disable Rails/OutputSafety
  end
end
