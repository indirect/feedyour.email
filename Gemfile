source "https://rubygems.org"
ruby Pathname.new(__dir__).join(".ruby-version").read
gem "rails", "~> 7.0"

group :development, :test do
  gem "assert_json", "~> 0.4.1", require: false
  gem "debug", "~> 1.7", platforms: %i[mri mingw x64_mingw]
  gem "json-schema", "~> 3.0", require: false
  gem "libxml-ruby", "~> 4.0.0"
  gem "pry-rails", "~> 0.3.9"
  gem "rspec-rails", "~> 6.0"
end

group :development do
  gem "annotate", "~> 3.2"
  gem "brakeman", "~> 5.4", require: false
  gem "bundler-audit", "~> 0.9.1", require: false
  gem "code-scanning-rubocop", "~> 0.6.1", require: false,
    github: "arthurnn/code-scanning-rubocop"
  gem "erb_lint", "~> 0.3.1", require: false
  gem "guard-bundler-audit", "~> 0.1.5", require: false
  gem "guard-erb_lint", github: "Driversnote-Dev/guard-erb_lint", require: false
  gem "guard-rspec", "~> 4.7", require: false
  gem "guard-rubocop", "~> 1.5", require: false
  gem "guard-shell", "~> 0.7.2", require: false
  gem "hotwire-livereload", "~> 1.2"
  gem "rubocop-gemfile", "~> 0.1.0.beta3", require: false
  gem "rubocop-rails", "~> 2.17", require: false
  gem "rubocop-rspec", "~> 2.17", require: false
  gem "standard", "~> 1.16", require: false
  gem "web-console", "~> 4.2"
end

group :production do
  gem "lograge", "~> 0.12.0"
  gem "honeybadger", "~> 5.0"
end

gem "better_html", "~> 2.0"
gem "bootsnap", "~> 1.15", require: false
gem "importmap-rails", "~> 1.1"
gem "jb", "~> 0.8.0"
gem "nilify_blanks", "~> 1.4"
gem "pg", "~> 1.4"
gem "propshaft", "~> 0.6.4"
gem "puma", "~> 6.0"
gem "rack-canonical-host", "~> 1.1", require: false
gem "redis", "~> 5.0"
gem "tailwindcss-rails", "~> 2.0"
gem "turbo-rails", "~> 1.3"

gem "action-cable-redis-backport", "~> 1.0"
