require 'anemone'
require 'nokogiri'
require 'kconv'

id = 0
range = 1..1
range.each{ |num|
  Anemone.crawl("http://www.talentinsta.com/matome/index.php?p=%a5%c6%a5%e9%a5%b9%a5%cf%a5%a6%a5%b9",:depth_limit => 0) do |anemone|
	anemone.on_every_page do |page|
		doc = Nokogiri::HTML.parse(page.body.toutf8)
		body = doc.xpath('//a').each do |node|
			str = node.text
			# pos1 = str.index("http://www.talentinsta.com/tllink/tllink.php")
			# pos2 = str.index("ブログ")
			# if pos1 != nil
			# 	url = node.xpath('a').attribute('href').value
			# 	p id.to_s+","+str+","+url
			# 	id = id + 1
			# end
			url = node.attribute('href').value
			img = nil
			imgNode = node.xpath('img')
			if !imgNode.nil? && imgNode.to_s != ""
				# img = imgNode.attribute('src').value
				# p imgNode.to_s
				img = imgNode.attribute('src').value
			end
			pos3 = url.index("http://www.talentinsta.com/tllink/tllink.php?mode=jump")
			if pos3 != nil && img != nil
				p id.to_s+","+str+","+url+","+img
				id = id + 1
			end
    	end
	end
end
}


# /html/body/div[1]/table[3]/tbody/tr/td[1]/table[1]/tbody/tr[1]/td/a

# <a href="http://www.talentinsta.com/tllink/tllink.php?mode=jump&amp;id=2713" rel="nofollow"><img src="https://instagramimages-a.akamaihd.net/profiles/profile_325436600_75sq_1388132117.jpg" width="50" height="50" align="left" border="0" alt="山中美智子 Instagram"><span class="bold">山中美智子</span></a>

#/html/body/div[1]/table[3]/tbody/tr/td[1]/p
# body > div:nth-child(1) > table:nth-child(6) > tbody > tr > td:nth-child(1) > p:nth-child(5) > a