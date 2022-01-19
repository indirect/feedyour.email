host = ENV.key?("HEROKU_APP_NAME") ? "#{ENV["HEROKU_APP_NAME"]}.herokuapp.com" : ENV["HOST"]

if host
  Rails.application.config.hosts << host << /.+?\.#{host}/

  if ENV.key?("HEROKU_APP_NAME")
    # treat herokuapp.com like co.uk, dropping both
    ActionDispatch::Http::URL.tld_length = 2
  end

  Rails.application.config.after_initialize do
    ApplicationController.renderer.defaults.merge!(http_host: host, https: true)

    # This super gross hack is to work around a bug in Rails that doesn't apply the defaults
    # to existing instances of Renderer. https://github.com/rails/rails/issues/41795
    ApplicationController.instance_eval { @renderer = @renderer.new }

    [
      Rails.application.default_url_options,
      Rails.application.routes.default_url_options,
      ApplicationController.default_url_options,
      ApplicationMailer.default_url_options
    ].each { |opts| opts[:host] = host }
  end
end
