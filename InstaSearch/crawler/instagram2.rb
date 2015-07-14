require 'anemone'
require 'nokogiri'
require 'kconv'

id = 0

talentUrls = []
rows = []
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
			if url_ = node.attribute('href')
				url = url_.value
				img = nil
				imgNode = node.xpath('img')
				if !imgNode.nil? && imgNode.to_s != ""
					# img = imgNode.attribute('src').value
					# p imgNode.to_s
					img = imgNode.attribute('src').value
				end
				pos3 = url.index("http://www.talentinsta.com/tllink/tllink.php?mode=jump")
				if pos3 != nil && img != nil
					# p id.to_s+","+str+","+url+","+img
					talentUrls.push(url)
					rows.push(id.to_s+","+str+","+url+","+img)
					id = id + 1
				end

			end
    	end
	end
end

#公式インスタグラムのページURL取得
index = 0
talentUrls.each {|talentUrl|
	Anemone.crawl(talentUrl, :depth_limit => 0) do |anemone|
		anemone.on_every_page do |page|
			doc = Nokogiri::HTML.parse(page.body.toutf8)
			body = doc.xpath('//a').each do |node|
				url = node.attribute('href').value
				pos = url.index("instagram.com")
				if pos != nil
					# p url
					r = rows[index]
					rows[index] = r+","+url
					index = index+1
				end
			end
	    end
	end
}

rows.each {|r|
	p r
}


# p "URLS:"+talentUrls.to_s

#widget URLを取得したい。
#公式URLも




# /html/body/div[1]/table[3]/tbody/tr/td[1]/table[1]/tbody/tr[1]/td/a

# <a href="http://www.talentinsta.com/tllink/tllink.php?mode=jump&amp;id=2713" rel="nofollow"><img src="https://instagramimages-a.akamaihd.net/profiles/profile_325436600_75sq_1388132117.jpg" width="50" height="50" align="left" border="0" alt="山中美智子 Instagram"><span class="bold">山中美智子</span></a>

#/html/body/div[1]/table[3]/tbody/tr/td[1]/p
# body > div:nth-child(1) > table:nth-child(6) > tbody > tr > td:nth-child(1) > p:nth-child(5) > a