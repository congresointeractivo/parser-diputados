#!/usr/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'json'
require 'optparse'

options = {}
optparse = OptionParser.new do |option_parser|
  option_parser.banner = "Usage: parser_diputados.rb [options]"

  option_parser.on("-o", "--output FILENAME", "Save the output to a file") do |o|
    options[:output] = o
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
data[:bloques] = []
data[:diputados] = []

doc.css("#tablesorter tbody tr").each do |el|
  next if el.css("td").empty?

  diputado = {}
  name = el
    .css("td")[1]
    .text
    .split(",")
    .map(&:strip)

  diputado[:apellido]       = name.first
  diputado[:nombre]         = name.last
  diputado[:provincia]      = el.css("td")[2].text
  diputado[:bloque]         = el.css("td")[5].text
  diputado[:inicio_mandato] = el.css("td")[3].text
  diputado[:fin_mandato]    = el.css("td")[4].text
  diputado[:email]          = parse_email el
  diputado[:url]            = parse_url el
  diputado[:imagen_url]     = el.css("td img")
                                .first['src']
                                .gsub("_medium", "")

  data[:diputados] << diputado
  data[:bloques] << diputado[:bloque]
end

data[:bloques].uniq!.sort!

if options[:output]
  File.open(options[:output], "w") do |file|
    file.puts data.to_json
  end
else
  $stdout.puts data.to_json
end
