require 'open-uri'
require 'json'

class Parser

  URL = "http://www.diputados.gov.ar/diputados/listadip.html"

  def initialize opts={}
    @options = opts
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

  private
  def fetch_html
    if @options[:cache]
      if File.exist?(cachefile)
        File.read(cachefile)
      else
        save_cache fetch_and_clean_html
      end
    else
      save_cache fetch_and_clean_html
    end
  end

  def fetch_and_clean_html
    open(URL)
      .read
      .gsub("<tbody>", "<tbody><tr>")
      .gsub("</tr>", "</tr><tr>");
  end

  def cachefile
    "html.cache"
  end

  def save_cache content
    File.open(cachefile, 'w+') do |file|
      file.write(content)
    end
    content
  end
end
