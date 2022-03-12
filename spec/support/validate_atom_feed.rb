require "xml/libxml"

module ValidateJsonFeed
  def validate_atom_feed(content = @response.body)
    relaxng_document = XML::Document.file("spec/support/atom.rng.xml")
    relaxng_schema = XML::RelaxNG.document(relaxng_document)
    XML::Document.string(content).validate_relaxng(relaxng_schema)
  end
end
