class BodyFormatter
  def initialize(html_body)
    @html_body = html_body
  end

  def format(from_name)
    return if @html_body.blank?

    case from_name
    when "Matt Levine"
      body = @html_body
        .gsub("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\r\n", "")
        .gsub("</style>", "[class^=\"liveintent\"] { display: none !important; }</style>")
        .gsub("</head>", ApplicationController.render(partial: "posts/injected_header"))
        .gsub(/<table class="footer".*/m, "</body></html>")
      return body if body.match?(/class="footnote-content"/)

      body.gsub!(/href="#footnote-(\d+)"/) { "href=\"#footnote-#{$1}\" class=\"footnote-index\"" }
      body.gsub!(/id="footnote-(\d+)"/) { "id=\"footnote-#{$1}\" class=\"footnote-content\"" }
      return body if body.match?(/class="footnote-content"/)

      body.gsub(/(.{4})(\[\d+\])/) do
        if $1 == "<em>"
          "<em id=\"fn#{$2[1...-1]}\">#{$2}"
        else
          "#{$1}<a class=\"footnote\" href=\"#fn#{$2[1...-1]}\">#{$2}</a>"
        end
      end
    else
      @html_body
    end
  end
end
