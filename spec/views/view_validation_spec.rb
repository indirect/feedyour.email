require "rails_helper"
require "better_html/test_helper/safe_erb_tester"

RSpec.describe "view validation" do
  include BetterHtml::TestHelper::SafeErbTester

  erb_files = Rails.root.join("app/views")
    .glob("**/{*.htm,*.html,*.htm.erb,*.html.erb,*.html+*.erb}")

  erb_files.each do |filename|
    pathname = filename.relative_path_from(Rails.root)

    describe pathname do
      it "has no missing javascript escapes" do
        assert_erb_safety File.read(filename)
      end

      it "has no html errors" do
        data = File.read(filename)
        BetterHtml::BetterErb::ErubiImplementation.new(data).validate!
      end
    end
  end
end
