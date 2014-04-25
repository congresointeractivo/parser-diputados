require 'open-uri'
require 'json'

class Parser

  URL = "http://www.diputados.gov.ar/diputados/listadip.html"

  def initialize opts={}
    @options = opts
  end

  def fetch_and_clean_html
    cachefile = "html.cache"

    if File.exist?(cachefile)
      content = File.read(cachefile)
    else
      content = open(URL)
        .read
        .gsub("<tbody>", "<tbody><tr>")
        .gsub("</tr>", "</tr><tr>");

      File.open(cachefile, 'w+') do |file|
        file.write(content)
      end
    end

    content
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
      if !@options[:instance_name]
        $stdout.puts parse.to_json
      else
        parser_popit parse
      end
    end
  end
end
