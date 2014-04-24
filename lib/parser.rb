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
      end
    end

    ##Request to API
    if @options[:instance_name] 
      parser_popit parse
    end


  end
end
