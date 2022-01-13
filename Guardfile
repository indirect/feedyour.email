# Restart puma-dev when application things change
guard :shell do
  watch("Gemfile.lock") { `touch tmp/restart.txt` }
  watch(%r{^config|lib/.*}) { `touch tmp/restart.txt` }
end

# Just make everything standard. Please. I don't want to talk about it.
guard :standardrb, fix: false, all_on_start: false, progress: false do
  watch(/.+\.rb$/)
end

# Run tests automatically as related files change
guard :rspec, cmd: "bin/rspec", bundler_env: :inherit do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      rspec.spec.call("routing/#{m[1]}_routing"),
      rspec.spec.call("controllers/#{m[1]}_controller"),
      rspec.spec.call("requests/#{m[1]}")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper) { rspec.spec_dir }
  watch(rails.routes) { "#{rspec.spec_dir}/routing" }
  watch(rails.app_controller) { "#{rspec.spec_dir}/controllers" }

  # Capybara features specs
  watch(rails.view_dirs) { |m| rspec.spec.call("requests/#{m[1]}") }
  watch(rails.layouts) { |m| rspec.spec.call("requests/#{m[1]}") }
end
