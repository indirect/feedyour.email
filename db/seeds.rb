# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Feed.find_or_create_by!(token: "somefeed", name: "Money Stuff")

json = JSON.parse(Rails.root.join("spec/support/body.json").read)
params = Griddler::Postmark::Adapter.normalize_params(json.deep_symbolize_keys)
email = Griddler::Email.new(params)
EmailProcessor.new(email).process(token: "somepost")
