require 'open-uri'
require 'parser'

class CommissionParser < Parser

  def self.parse username, opts={}
    options = opts.dup
    options[:username] = username
    new(options).parse
  end

  def initialize opts={}
    @options  = opts
    @username = @options.fetch :username
  end

  def parse
    commissions = []
    doc = Nokogiri::HTML fetch_html
    doc.css("#tablaComisiones tbody tr").each do |el|
      commission = {}
      commission[:name] = parse_name el
      commission[:function] = parse_function el
      commissions << commission
    end
    commissions
  end

  private
  def parse_name el
    capitalize_each_word el.css("td")[0].text
  end

  def parse_function el
    capitalize_each_word el.css("td")[1].text
  end

  def cachefile
    ".cache/#{@username}_commissions.html"
  end

  def url
    "http://www.diputados.gov.ar/diputados/#{@username}/comisiones.html" 
  end
end

