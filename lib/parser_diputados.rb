require 'nokogiri'
require 'parser'
require 'set'

class ParserDiputados < Parser

  def fetch_and_clean_html
    open(URL)
      .read
      .gsub("<tbody>", "<tbody><tr>")
      .gsub("</tr>", "</tr><tr>")
  end

  def parse_email element
    username = element
      .css("td a")
      .first['href']
      .split("/")[2]
      .strip

    "#{username}@diputados.gob.ar"
  end

  def parse_url element
    path = element.css("td a").first["href"]
    "http://www.diputados.gov.ar#{path}"
  end

  def parse_name element
    element
      .css("td")[1]
      .text
      .split(",")
      .map(&:strip)
      .reverse
  end

  def parse
    doc = Nokogiri::HTML fetch_and_clean_html

    data = {}
    data[:bloques] = []
    data[:diputados] = []

    bloques = Set.new

    doc.css("#tablesorter tbody tr").each do |el|
      next if el.css("td").empty?

      diputado = {}
      name = parse_name el

      diputado[:apellido]       = name.last
      diputado[:nombre]         = name.first
      diputado[:provincia]      = el.css("td")[2].text.strip
      diputado[:bloque]         = el.css("td")[5].text.strip
      diputado[:inicio_mandato] = el.css("td")[3].text
      diputado[:fin_mandato]    = el.css("td")[4].text
      diputado[:email]          = parse_email el
      diputado[:url]            = parse_url el
      diputado[:imagen_url]     = el.css("td img")
                                    .first['src']
                                    .gsub("_medium", "")

      data[:diputados] << diputado
      bloques << diputado[:bloque]
    end

    data[:bloques] = bloques.to_a
    data
  end

end
