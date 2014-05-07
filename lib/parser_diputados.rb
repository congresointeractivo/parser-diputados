require 'nokogiri'
require 'parser'
require 'commission_parser'
require 'i18n'

I18n.enforce_available_locales = false

class ParserDiputados < Parser

  def parse
    doc = Nokogiri::HTML fetch_html

    data = {}
    data[:diputados] = []

    doc.css("#tablesorter tbody tr").each do |el|
      next if el.css("td").empty?

      diputado = {}
      diputado[:name]       = parse_name el

      diputado[:slug]       = slug diputado[:name]
      diputado[:district]   = parse_district el
      diputado[:start_date] = parse_date extract_text(el, :start_date)
      diputado[:end_date]   = parse_date extract_text(el, :end_date)
      diputado[:email]      = parse_email el
      diputado[:url]        = parse_url el
      diputado[:block]      = parse_block el

      diputado[:images] = []
      
      image = {}
      image[:url] = parse_image_url el

      diputado[:images] << image

      diputado[:contact_details]  = [contact_details(diputado[:email])]
      diputado[:commissions] = parse_commissions parse_username(el)
      data[:diputados] << diputado
    end

    data
  end


  private
  def fetch_and_clean_html
    super
      .gsub("<tbody>", "<tbody><tr>")
      .gsub("</tr>", "</tr><tr>")
  end

  def parse_commissions username
    CommissionParser.parse username, @options
  end

  def parse_username element
    element
      .css("td a")
      .first['href']
      .split("/")[2]
      .strip
  end

  def parse_email element
    username = parse_username element
    "#{username}@diputados.gob.ar"
  end

  def parse_url element
    path = element.css("td a").first["href"]
    "http://www.diputados.gov.ar#{path}"
  end

  def parse_name element
    clean_name = extract_text(element, :name)
                  .split(",")
                  .map(&:strip)
                  .reverse
                  .join(" ")

    capitalize_each_word clean_name
  end

  def slug text
    I18n.transliterate(text).gsub(" ","-").downcase
  end

  def parse_image_url element
    element
      .css("td img")
      .first['src']
      .gsub("_medium", "")
  end

  def parse_district element
    capitalize_each_word extract_text(element, :district)
      .split
      .map(&:capitalize)
      .join(" ")
  end

  def parse_date text
    Date.strptime text.strip,'%d/%m/%Y'
  end

  def contact_details email
    {
      label: "email",
      type:  "email",
      value: email
    }
  end

  def parse_block el
    extract_text(el, :block).
      capitalize
  end

  def positions_map
    @postions_map ||= {
      image_url: 0,
      name: 1,
      district: 2,
      start_date: 3,
      end_date: 4,
      block: 5
    }
  end

  def extract_text element, name
    index = positions_map[name]
    element.css("td")[index].text.strip rescue nil
  end

  def url
    "http://www.diputados.gov.ar/diputados/listadip.html"
  end

  def cachefile
    ".cache/listado_diputados.html"
  end

end
