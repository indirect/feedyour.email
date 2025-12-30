class PostsController < ApplicationController
  def index
    @feed = Feed.find_by!(token: params[:feed_id])
    @posts = @feed.posts
  end

  def search
    return redirect_to feed_posts_path if params[:q].blank?

    index
    @posts = @posts.search(params[:q].gsub(/[^a-zA-Z0-9_+*^():]/, "")).to_a
    render :index
  rescue ActiveRecord::StatementInvalid => e
    raise(e) unless e.cause.is_a?(SQLite3::SQLException)

    flash.now[:search_failed] = e.cause.message
    render :index
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
