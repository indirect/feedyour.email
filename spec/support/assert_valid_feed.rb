require "feed_validator"

module W3C
  class FeedValidator
    # Parse a response from the w3c feed validation service.
    # Used by assert_valid_feed
    def parse(response)
      clear
      if response.respond_to?(:body)
        parse_response(response.body)
      else
        parse_response(response)
      end
    end
  end

  module FeedValidator::Assertions
    # Assert that feed is valid according the {W3C Feed Validation online service}[http://validator.w3.org/feed/].
    # By default, it validates the contents of @response.body, which is set after calling
    # one of the get/post/etc helper methods in rails. You can also pass it a string to be validated.
    # Validation errors, warnings and informations, if any, will be included in the output. The response from the validator
    # service will be cached in the system temp directory to minimize duplicate calls.
    #
    # For example in Rails, if you have a FooController with an action Bar, put this in foo_controller_test.rb:
    #
    #   def test_bar_valid_feed
    #     get :bar
    #     assert_valid_feed
    #   end
    #
    def assert_valid_feed(fragment = @response.body)
      v = W3C::FeedValidator.new
      filename = File.join Dir.tmpdir, "feed." + Digest::MD5.hexdigest(fragment).to_s
      begin
        response = File.open(filename) { |f| Marshal.load(f) }
        v.parse(response)
      rescue
        unless v.validate_data(fragment)
          warn("Sorry! could not validate the feed.")
          return assert(true, "")
        end
        File.open(filename, "w+") { |f| Marshal.dump v.response, f }
      end
      assert(v.valid?, v.valid? ? "" : v.to_s)
    end
  end
end
