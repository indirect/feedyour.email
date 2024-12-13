class RequestsController < ApplicationController
  def show
    case params[:id]
    when "error"
      raise "oh no"
    when "headers"
      render plain: request.headers.to_h.map { |k, v| "#{k}: #{v}" }.sort_by(&:first).join("\n")
    when "cloudflare"
      render plain: JSON.pretty_generate(
        "Rails.configuration.cloudflare": Rails.configuration.cloudflare,
        "Importer.cloudflare_ips": CloudflareRails::Importer.cloudflare_ips,
        "CloudflareRails::FallbackIps::IPS_V4": CloudflareRails::FallbackIps::IPS_V4,
        "CloudflareRails::FallbackIps::IPS_V6": CloudflareRails::FallbackIps::IPS_V6,
        "request.headers['REMOTE_ADDR']": request.headers["REMOTE_ADDR"],
        "request.forwarded_for": request.forwarded_for,
        "request.remote_ip": request.remote_ip,
        "request.ip": request.ip,
        "request.local?": request.local?,
        "request.cloudflare?": request.cloudflare?
      )
    else
      head :not_found
    end
  end
end
