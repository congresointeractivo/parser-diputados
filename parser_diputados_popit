#!/usr/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'json'
require 'optparse'
require 'i18n'
require 'popit'

options = {}
optparse = OptionParser.new do |option_parser|
  option_parser.banner = "Usage: parser_diputados.rb [options]"

  option_parser.on("-o", "--output FILENAME", "Save the output to a file") do |o|
    options[:output] = o
  end

  option_parser.on("-i n", "--instance=n", "Send every row this instance of the PopIt Api on popit.mysociety.org. Default legisladores-ar [INSTANCE]") do |instance|
    options[:instance_name] = instance
  end

  option_parser.on("-u n", "--user=n", "Api user [USERNAME]") do |user|
    options[:api_user] = user
  end

  option_parser.on("-p n", "--password=n", "Api password [PASSWORD]") do |pass|
    options[:api_pass] = pass
  end
end
optparse.parse!


URL_DIPUTADOS = "http://www.diputados.gov.ar/diputados/listadip.html"

def fetch_and_clean_html
  open(URL_DIPUTADOS)
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

doc = Nokogiri::HTML fetch_and_clean_html

data = {}
#data[:bloques] = []
data[:diputados] = []

doc.css("#tablesorter tbody tr").each do |el|
  next if el.css("td").empty?

  diputado = {}
  name = el
    .css("td")[1]
    .text
    .split(",")
    .map(&:strip)
  diputado[:name]             = name.last.strip.capitalize + " " + name.first.strip.capitalize
  diputado[:slug]             = I18n.transliterate(diputado[:name]).gsub(" ","-").downcase;

  diputado[:images]           =  {}
  diputado[:images][:url]     = el.css("td img")
                                .first['src']
                                .gsub("_medium", "")

  diputado[:parliamentarian_period]               = []
  
  period = {}
  period[:start_date]  = el.css("td")[3].text.strip
  period[:end_date]    = el.css("td")[4].text.strip
  period[:district]    = el.css("td")[2].text.strip.capitalize
  period[:position]    = "diputado"

  diputado[:parliamentarian_period] << period


  diputado[:title]            = "Diputado"


  diputado[:contact_details]               = []

  contact = {}
  contact[:label]  = "email"
  contact[:type]    = "email"
  contact[:value]    = parse_email el

  diputado[:contact_details] << contact


  diputado[:bloque]      = el.css("td")[5].text.strip.capitalize

  ## Missing info for the new structure

  # diputado[:links]               = {}
  # diputado[:links][:note]  = "Link name"
  # diputado[:links][:url]    = "url"

  # diputado[:commissions]      = {}

  # diputado[:birth_date]       = ""
  # diputado[:personal_info]      = {}
  # diputado[:electoral_info]      = {}
  # diputado[:represent]      = {}
  # diputado[:represent][:district]    = el.css("td")[2].text

  ## Old structure

  # diputado[:apellido]       = name.first
  # diputado[:nombre]         = name.last
  # diputado[:provincia]      = el.css("td")[2].text
  # diputado[:bloque]         = el.css("td")[5].text
  # diputado[:inicio_mandato] = el.css("td")[3].text
  # diputado[:fin_mandato]    = el.css("td")[4].text
  # diputado[:email]          = parse_email el
  # diputado[:url]            = parse_url el
  # diputado[:imagen_url]     = el.css("td img")
  #                               .first['src']
  #                               .gsub("_medium", "")

  data[:diputados] << diputado
  # data[:bloques] << diputado[:bloque]

  if options[:instance_name] 
    api = PopIt.new :instance_name => options[:instance_name], :user => options[:api_user], :password => options[:api_pass]
    begin
      exists = api.persons.get :slug => diputado[:slug]

      if exists
        id = exists.first["id"]
        puts "Updating " + diputado[:name]
        response = api.persons(id.to_s).put diputado
      else
        puts "Creating " + diputado[:name]
        response = api.persons.post diputado
      end
    rescue
      p diputado
      raise
    end
  end

end

#data[:bloques].uniq!.sort!

if options[:output]
  File.open(options[:output], "w") do |file|
    file.puts data.to_json
  end
else
  $stdout.puts data.to_json
end
