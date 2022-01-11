# This file is used by Rack-based servers to start the application.
require_relative "config/environment"
require "rack/canonical_host"

use Rack::CanonicalHost, ENV["HOST"] if ENV.key?("HOST")
run Rails.application
Rails.application.load_server
