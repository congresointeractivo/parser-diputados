require 'open-uri'
require 'json'

class Parser

  URL = "http://www.diputados.gov.ar/diputados/listadip.html"

  def initialize opts={}
    @options = opts
  end

  def fetch_and_clean_html
    open(URL)
      .read
      .gsub("<tbody>", "<tbody><tr>")
      .gsub("</tr>", "</tr><tr>")
  end

  def parse
    raise NotImplementedError
  end

  def run
    if @options[:output]
      File.open(@options[:output], "w") do |file|
        file.puts parse.to_json
      end
    else
      $stdout.puts parse.to_json
    end
  end
end
