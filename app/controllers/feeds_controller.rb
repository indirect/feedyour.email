class FeedsController < ApplicationController
  def new
    @feed = Feed.new
  end

  def show
    @feed = Feed.find_by!(token: params[:id])
    return if request.format.html?

    @feed.fetch_or_expire!
    return http_cache_forever(public: true) if feed.expired_at?

    fresh_when @feed
    expires_in 1.hour, public: true if @feed.created_at < 1.day.ago
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
