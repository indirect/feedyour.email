def set_up_host(host)
  return unless host

  Rails.application.config.hosts << host << /.+?\.#{host}/

  # How many domain segments should we ignore? All but the first.
  ActionDispatch::Http::URL.tld_length = host.count(".")

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

set_up_host(ENV["HOST"])
