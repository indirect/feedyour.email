source "https://rubygems.org"
ruby "3.1.0"
gem "rails", "~> 7.0"

group :development, :test do
  gem "debug", "~> 1.4", platforms: %i[mri mingw x64_mingw]
  gem "feedvalidator", "~> 0.2.2", require: false
  gem "rspec-rails", "~> 5.0"
end

group :development do
  gem "brakeman", "~> 5.2", require: false
  gem "bundler-audit", "~> 0.9.0", require: false
  gem "code-scanning-rubocop", "~> 0.5.0", require: false,
    github: "indirect/code-scanning-rubocop"
  gem "erb_lint", "~> 0.1.1", require: false
  gem "guard-bundler-audit", "~> 0.1.5", require: false
  gem "guard-erb_lint", github: "Driversnote-Dev/guard-erb_lint", require: false
  gem "guard-rspec", "~> 4.7", require: false
  gem "guard-rubocop", "~> 1.5", require: false
  gem "guard-shell", "~> 0.7.2", require: false
  gem "hotwire-livereload", "~> 1.0"
  gem "rubocop-gemfile", "~> 0.1.0.beta3", require: false
  gem "rubocop-rails", "~> 2.13", require: false
  gem "rubocop-rspec", "~> 2.7", require: false
  gem "standard", "~> 1.6", require: false
  gem "web-console", "~> 4.2"
end

group :production do
  gem "lograge", "~> 0.11.2"
  gem "honeybadger", "~> 4.9"
end

gem "better_html", "~> 1.0"
gem "bootsnap", "~> 1.9", require: false
gem "griddler-postmark", "~> 1.0", github: "r38y/griddler-postmark"
gem "importmap-rails", "~> 1.0"
gem "nilify_blanks", "~> 1.4"
gem "pg", "~> 1.2"
gem "puma", "~> 5.5"
gem "rack-canonical-host", "~> 1.1", require: false
gem "redis", "~> 4.5"
gem "sprockets-rails", "~> 3.4"
gem "tailwindcss-rails", "~> 2.0"
gem "turbo-rails", "~> 1.0"
