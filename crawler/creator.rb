require 'anemone'
require 'nokogiri'
require 'kconv'

#アカウント取得
# 名前,talentinstaのURL,アイコン画像URL,オフィシャルURL

#singer 1..32
#http://www.talentinsta.com/tllink/tllink.php?mode=ct&ct=2&p=#{num}

#talentwoman 1..18
# http://www.talentinsta.com/tllink/tllink.php?mode=ct&ct=1&p=#{num}
# model and bikini 1..42(20)
# http://www.talentinsta.com/tllink/tllink.php?mode=ct&ct=5&p=#{num}
# MAXpage 20
# http://www.talentinsta.com/tllink/tllink.php?mode=ct&ct=4&p=1

id = 0

talentUrls = []
rows = []
range = 1..6
range.each{ |num|
	Anemone.crawl("http://www.talentinsta.com/tllink/tllink.php?mode=ct&ct=14&p=#{num}",:depth_limit => 0) do |anemone|
		anemone.on_every_page do |page|
			doc = Nokogiri::HTML.parse(page.body.toutf8)
			body = doc.xpath('//p').each do |node|
				str = node.text
				aNode = node.xpath("a")
				# p node.to_s
				imgNodes = node.xpath("img")

				iconImageNode = nil
				imgNodes.each do |imgNode|
					# p imgNode.to_s
					pos = imgNode.to_s.index("talentinsta")
					if pos == nil  #talentinstaの文字を含まないのは、アイコンURLと認識してつめる
						iconImageNode = imgNode
					end
				end
				imageUrl = iconImageNode.attribute("src").value
				# p imageUrl
				# p imgNodes.to_s
				name = aNode.text
				path = aNode.attribute('href').value
				url = "http://www.talentinsta.com"+path
				rows.push(id.to_s+","+name+","+url+","+imageUrl)
				talentUrls.push(url)
				id = id+1
	    	end
		end
	end
}

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


# imageUrlは2パターンある
# "https://instagramimages-a.akamaihd.net/profiles/profile_363567749_75sq_1367585195.jpg"
# "https://igcdn-photos-c-a.akamaihd.net/hphotos-ak-xpf1/t51.2885-19/11008213_1021562717873922_608795827_a.jpg"


# /html/body/div[1]/table[3]/tbody/tr/td[1]/table[1]/tbody/tr[1]/td/a

# <a href="http://www.talentinsta.com/tllink/tllink.php?mode=jump&amp;id=2713" rel="nofollow"><img src="https://instagramimages-a.akamaihd.net/profiles/profile_325436600_75sq_1388132117.jpg" width="50" height="50" align="left" border="0" alt="山中美智子 Instagram"><span class="bold">山中美智子</span></a>

#/html/body/div[1]/table[3]/tbody/tr/td[1]/p
# body > div:nth-child(1) > table:nth-child(6) > tbody > tr > td:nth-child(1) > p:nth-child(5) > a