class PostsController < ApplicationController
  def index
    @feed = Feed.find_by(token: params[:feed_id])
    @posts = @feed.posts
  end

  def show
    @post = Post.where(token: params[:id]).first
    render html: @post.payload["raw_html"]
  end
end
