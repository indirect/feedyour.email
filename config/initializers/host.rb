if ENV.key?("HOST")
  Rails.application.config.hosts << ENV["HOST"]

  Rails.application.config.after_initialize do
    ApplicationController.renderer.defaults.merge!(http_host: ENV["HOST"], https: true)

    # This super gross hack is to work around a bug in Rails that doesn't apply the defaults
    # to existing instances of Renderer. https://github.com/rails/rails/issues/41795
    ApplicationController.instance_eval { @renderer = @renderer.new }

    [
      Rails.application.default_url_options,
      Rails.application.routes.default_url_options,
      ApplicationController.default_url_options,
      ApplicationMailer.default_url_options
    ].each { |opts| opts[:host] = ENV["HOST"] }
  end
end
