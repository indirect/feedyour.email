class PostsController < ApplicationController
  def index
    @feed = Feed.find_by!(token: params[:feed_id])
    @posts = @feed.posts
  end

  def show
    @post = Post.find_by!(token: params[:id])
    if @post.html_body
      render html: @post.html_body.html_safe # rubocop:disable Rails/OutputSafety
    else
      render plain: @post.text_body
    end
  end
end
