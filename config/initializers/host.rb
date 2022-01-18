if ENV.key?("HOST")
  Rails.application.config.hosts << ENV["HOST"]

  Rails.application.config.after_initialize do
    ApplicationController.renderer.defaults.merge!(http_host: ENV["HOST"], https: true)

    [
      Rails.application.default_url_options,
      Rails.application.routes.default_url_options,
      ApplicationController.default_url_options,
      ApplicationMailer.default_url_options
    ].each { |opts| opts[:host] = ENV["HOST"] }
  end
end
