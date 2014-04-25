require 'nokogiri'
require 'parser'
require 'i18n'

class ParserDiputados < Parser

  def parse
    doc = Nokogiri::HTML fetch_and_clean_html

    data = {}
    data[:diputados] = []

    doc.css("#tablesorter tbody tr").each do |el|
      next if el.css("td").empty?

      diputado = {}

      diputado[:name]       = parse_name el
      diputado[:slug]       = slug diputado[:name]
      diputado[:district]   = parse_district el
      diputado[:start_date] = parse_date extract_text(el, positions_map[:start_date])
      diputado[:end_date]   = parse_date extract_text(el, positions_map[:end_date])
      diputado[:email]      = parse_email el
      diputado[:url]        = parse_url el
      diputado[:block]      = parse_block el

      diputado[:images] = {}
      diputado[:images][:url] = parse_image_url el

      diputado[:contact_details]  = [contact_details(diputado[:email])]

      data[:diputados] << diputado
    end

    data
  end


  private
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
    clean_name = extract_text(element, positions_map[:name])
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
    capitalize_each_word extract_text(element, positions_map[:district])
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
    extract_text(el, positions_map[:block]).
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

  def extract_text element, index
    element.css("td")[index].text.strip rescue nil
  end

  def capitalize_each_word text
    text
      .split(" ")
      .map(&:capitalize)
      .join(" ")
  end
end
