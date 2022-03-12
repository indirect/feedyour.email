require "json-schema"
require "xml/libxml"

module ValidateFeed
  JSON_SCHEMA = Rails.root.join("spec/support/json_feed_schema.json").read
  ATOM_SCHEMA = XML::RelaxNG.document(XML::Document.file("spec/support/atom.rng.xml"))

  def validate_json_feed
    JSON::Validator.fully_validate(JSON_SCHEMA, response.body)
  end

  def validate_atom_feed(content = @response.body)
    XML::Document.string(content).validate_relaxng(ATOM_SCHEMA)
  end
end
