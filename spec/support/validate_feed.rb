require "json-schema"
require "xml/libxml"

module ValidateFeed
  JSON_SCHEMA = Rails.root.join("spec/support/json_feed_schema.json").read

  def validate_json_feed
    JSON::Validator.fully_validate(JSON_SCHEMA, response.body)
  end

  def validate_atom_feed(content = @response.body)
    relaxng_document = XML::Document.file("spec/support/atom.rng.xml")
    relaxng_schema = XML::RelaxNG.document(relaxng_document)
    XML::Document.string(content).validate_relaxng(relaxng_schema)
  end
end
