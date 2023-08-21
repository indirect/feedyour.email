module ValidateFeed
  extend RSpec::Matchers::DSL

  matcher :be_valid_atom_feed do
    match do |body|
      require "xml/libxml"
      XML::Document.string(body).validate_relaxng(ValidateFeed.atom_schema)
    rescue LibXML::XML::Error => e
      @message = e.message
      false
    end

    failure_message do |actual|
      @message.gsub("Fatal error: ", "Invalid Atom feed: ")
    end
  end

  matcher :be_valid_json_feed do
    match do |body|
      require "json-schema"
      @actual = JSON::Validator.fully_validate(ValidateFeed.json_schema, body)
      @actual.empty?
    end

    failure_message do |actual|
      "JSON validator returned errors:\n" +
        @actual.map { |e| "  - #{e}" }.join("\n")
    end
  end

  def self.json_schema
    @json_schema ||= Rails.root.join("spec/support/json_feed_schema.json").read
  end

  def self.atom_schema
    require "xml/libxml"
    @atom_schema ||= XML::RelaxNG.document(
      XML::Document.file("spec/support/atom.rng.xml")
    )
  end
end
