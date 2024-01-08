source "https://rubygems.org"
ruby Pathname.new(__dir__).join(".ruby-version").read
gem "rails", "~> 7.1"
gem "mail", "< 2.9.0"

group :development, :test do
  gem "assert_json", "~> 1.0.0", require: false
  gem "debug", "~> 1.9", platforms: %i[mri mingw x64_mingw]
  gem "json-schema", "~> 4.1", require: false
  gem "libxml-ruby", "~> 4.1.2"
  gem "pry-rails", "~> 0.3.9"
  gem "rspec-rails", "~> 6.1"
end

group :development do
  gem "annotate", "~> 3.2"
  gem "brakeman", "~> 6.1", require: false
  gem "bundler-audit", "~> 0.9.1", require: false
  gem "code-scanning-rubocop", "~> 0.6.1", require: false,
    github: "arthurnn/code-scanning-rubocop"
  gem "dockerfile-rails", "~> 1.6"
  gem "erb_lint", "~> 0.5.0", require: false
  gem "guard-bundler-audit", "~> 0.1.5", require: false
  gem "guard-erb_lint", github: "Driversnote-Dev/guard-erb_lint", require: false
  gem "guard-rspec", "~> 4.7", require: false
  gem "guard-rubocop", "~> 1.5", require: false
  gem "guard-shell", "~> 0.7.2", require: false
  gem "hotwire-livereload", "~> 1.3"
  gem "rubocop-gemfile", "~> 0.1.0.beta3", require: false
  gem "rubocop-rails", "~> 2.23", require: false
  gem "rubocop-rspec", "~> 2.26", require: false
  gem "standard", "~> 1.33", require: false
  gem "web-console", "~> 4.2"
end

group :production do
  gem "lograge", "~> 0.14.0"
  gem "honeybadger", "~> 5.4"
end

gem "better_html", "~> 2.0"
gem "bootsnap", "~> 1.17", require: false
gem "brotli", "~> 0.4.0"
gem "importmap-rails", "~> 2.0"
gem "jb", "~> 0.8.2"
gem "nilify_blanks", "~> 1.4"
gem "propshaft", "~> 0.8.0"
gem "puma", "~> 6.4"
gem "rack-canonical-host", "~> 1.2", require: false
gem "redis", "~> 5.0"
gem "sqlite3", "~> 1.7"
gem "tailwindcss-rails", "~> 2.2"
gem "turbo-rails", "~> 1.5"

gem "sequel_pg", "~> 1.17", require: false
