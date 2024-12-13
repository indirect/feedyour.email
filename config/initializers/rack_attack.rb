# Block requests outside cloudflare (unless they are to the root, allow those for redirection)
# Rack::Attack.blocklist("CloudFlare bypass") { |req| req.path != "/" && !req.cloudflare? } if defined?(Rack::Attack)
