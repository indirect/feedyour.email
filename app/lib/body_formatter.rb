class BodyFormatter
  def initialize(html_body)
    @html_body = html_body
  end

  def format
    @html_body
      .gsub("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\r\n", "")
      .gsub("img {\nmax-width: 550px;\n}", "img { max-width: 100% }")
      .gsub("max-width: 550px; width: 100% !important", "width: 100% !important")
  end
end
