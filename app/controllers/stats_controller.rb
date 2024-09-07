class StatsController < ApplicationController
  def index
    @stats = {
      "Feeds Total" => Feed.count,
      "Feeds Throttled" => Feed.throttled.count,
      "Feeds Expired" => Feed.expired.count,
      "Posts All Time" => Post.count,
      "Posts Last Week" => Post.last_week.count,
      "Posts Last Hour" => Post.last_hour.count
    }
  end
end
