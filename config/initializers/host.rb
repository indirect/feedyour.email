if ENV.key?("HOST")
  Rails.application.config.hosts << ENV["HOST"]
end
