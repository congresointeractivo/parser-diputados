require 'open-uri'
require 'json'

class Parser

  def initialize opts={}
    @options = opts
  end

  def parse
    raise NotImplementedError
  end

  def run
    if @options[:output]
      File.open @options[:output], "w" do |file|
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
      if File.exist? cachefile
        File.read cachefile
      else
        save_cache fetch_and_clean_html
      end
    else
      save_cache fetch_and_clean_html
    end
  end

  def fetch_and_clean_html
    open(url).read
  end


  def save_cache content
    File.open cachefile, 'w+' do |file|
      file.write content
    end
    content
  end

  def url
    raise NotImplementedError
  end

  def cachefile
    raise NotImplementedError
  end

  def capitalize_each_word text
    text
      .split(" ")
      .map(&:capitalize)
      .join(" ")
  end

end
