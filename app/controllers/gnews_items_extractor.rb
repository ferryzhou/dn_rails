# encoding: utf-8

require 'open-uri'
require 'rss'
require 'iconv'

class GnewsItem
  attr_accessor :raw_title, :raw_link, :raw_description
  attr_accessor :title, :link, :date, :description, :source, :count
  def to_s; "#{title}"; end
end

class GnewsItemsExtractor

def utf8_to_gb2312(utf8_str); Iconv.iconv('GBK', 'utf-8', utf8_str).join; end

def trim(str); str.strip! || str; end

def get_gnews_items(feed)

  gnews_items = Array.new

  feed.items.each { |item|
    begin
      gitem = GnewsItem.new
	  gitem.raw_title = item.title
	  gitem.raw_link = item.link
      gitem.raw_description = item.description
      gitem.date = item.date
	  
      i = item.title.index('-'); puts 'original title: ' + utf8_to_gb2312(item.title)
      gitem.title = trim(item.title[0..i-1]); puts 'new title: ' + utf8_to_gb2312(gitem.title)
      gitem.source = trim(item.title[i-item.title.length + 1 .. -1]); puts 'source: ' + utf8_to_gb2312(gitem.source)
	  
      gitem.link = extract_link(item.link); puts 'link: ' + gitem.link
	  
      #puts 'original description: ' + utf8_to_gb2312(item.description)
      gitem.count = extract_count(item.description)
      puts 'extracting content .....'
      gitem.description = extract_content(item.description)
	  
      #puts 'content: ' + utf8_to_gb2312(gitem.description)
      puts 'count: ' + gitem.count.to_s
	  
      gnews_items.push(gitem)
    rescue => e
      puts "exception happens!!!!!"
	  puts e.message
    end
  }

  gnews_items
end

def extract_content(description)
  i1 = description.rindex('...')
  si = description[0..i1].rindex('<font size="-1">')
  #puts 'description: ' + description
  #puts 'content xml: ' + description[si..i1+13]
  #REXML::Document.new(description[si..i1+13]).root.texts.join('')
  description[si..i1+13].gsub(/<\/?[^>]*>/, "")
end

def extract_count(description)
  count_pre = "此专题所有"
  i = description.index(count_pre)
  i.nil? ? 1 : description[i + count_pre.length + 1 .. i + count_pre.length + 5].to_i
end

def extract_link(original_link)
  i = original_link.index("url=")
  i.nil? ? original_link : original_link[i+4 .. -1]
end

end # GnewsItemsExtractor

# return an array of GnewsItem
def extract_items(content)
  GnewsItemsExtractor.new.get_gnews_items(content)
end

