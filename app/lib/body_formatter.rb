class BodyFormatter
  def initialize(html_body)
    @html_body = html_body
  end

  def format(from_name)
    return if @html_body.blank?

    case from_name
    when "Matt Levine"
      @html_body
        .gsub("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\r\n", "")
        .gsub("img {\nmax-width: 550px;\n}", "[class^=\"liveintent\"] { display: none !important; }")
        .gsub("max-width: 550px; width: 100% !important", "width: 100% !important")
        .gsub("</head>", ApplicationController.render(partial: "posts/injected_header"))
        .gsub(/<td class="footer-wrapper.*/, "</tr></tbody></table></body></html>")
        .gsub(/(.{4})(\[\d+\])/) do
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
