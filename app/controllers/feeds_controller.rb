class FeedsController < ApplicationController
  def new
    @feed = Feed.new
  end

  def show
    @feed = Feed.find_by!(token: params[:id])
    return if request.format.html?

    @feed.fetch_or_expire!
    fresh_when @feed.last_post, public: true

    if @feed.expired_at?
      expires_in 100.years, public: true
    elsif @feed.created_at < 1.day.ago
      expires_in 1.day, public: true
    end
  end

  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      redirect_to feed_url(@feed), notice: "Feed was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feed_params
    params.fetch(:feed, {}).permit(:name)
  end
end
