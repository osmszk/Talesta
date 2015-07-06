
#http://www.talentinsta.com/ichiran/1/

require 'anemone'
require 'nokogiri'
require 'kconv'

# num = 100
# URL = "http://www.talentinsta.com/ichiran/#{num}/"
#スクレイピング
# Anemone.crawl(URL,:depth_limit => 0) do |anemone|
# 	anemone.on_every_page do |page|
# 		doc = Nokogiri::HTML.parse(page.body.toutf8)
# 		body = doc.xpath('//p').each do |node|
# 			str = node.text
# 			pos1 = str.index("Instagram")
# 			pos2 = str.index("ブログ")
# 			if pos1 == nil && pos2 == nil
# 				p str
# 			end
#     	end
# 	end
# end

id = 0
range = 1..2
range.each{ |num|
  Anemone.crawl("http://www.talentinsta.com/ichiran/#{num}/",:depth_limit => 0) do |anemone|
	anemone.on_every_page do |page|
		doc = Nokogiri::HTML.parse(page.body.toutf8)
		body = doc.xpath('//p').each do |node|
			str = node.text
			pos1 = str.index("Instagram")
			pos2 = str.index("ブログ")
			url = node.xpath('a').attribute('href').value
			if pos1 == nil && pos2 == nil
				p id.to_s+","+str+","+url
				id = id + 1
			end
    	end
	end
end
}



#/html/body/div[1]/table[3]/tbody/tr/td[1]/p
# body > div:nth-child(1) > table:nth-child(6) > tbody > tr > td:nth-child(1) > p:nth-child(5) > a