# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "action_mailbox/test_helper"

class Seeder
  include ActionMailbox::TestHelper

  def run!
    Feed.find_or_create_by!(token: "abc123", name: "Money Stuff")

    Rails.root.join("spec/fixtures/files").glob("money_stuff*.eml").each do |eml|
      mail = create_inbound_email_from_source(eml.read)
      PostMailbox.new(mail).process if mail
    end
  end
end

Seeder.new.run!
