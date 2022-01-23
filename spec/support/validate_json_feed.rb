require "json-schema"

module ValidateJsonFeed
  JSON_SCHEMA = Rails.root.join("spec/support/json_feed_schema.json").read

  def validate_json_feed
    JSON::Validator.fully_validate(JSON_SCHEMA, response.body)
  end
end
