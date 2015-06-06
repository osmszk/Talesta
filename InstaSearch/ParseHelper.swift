//
//  ParseHelper.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/05/31.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation


class ParseHelper {
    class func convertFollowerRankingFromHtml(html:String="") -> NSArray {
        
        var followerRankings = NSMutableArray()
        var error : NSError? = nil
        //TODO: エラーログ修正
        var parser : HTMLParser? = HTMLParser(html: html, encoding: NSUTF8StringEncoding, error: &error)//parse error
        let bodyNode :HTMLNode? = parser?.body
        
        let trNodes : Array<HTMLNode>? = bodyNode?.findChildTags("tr")
        var k = 0
        var trStartIndex  =  0
        
        //オプショナルのオブジェクト郡をfor-inでつかうときはアンラップしてからつかう
        //ref:http://stackoverflow.com/questions/26852656/loop-through-anyobject-results-in-does-not-have-a-member-named-generator
        if let trNodesUnwrap = trNodes{
            for trNode in trNodesUnwrap{
                let tdNodes : Array<HTMLNode>? = trNode.findChildTags("td")
                if let tdNodesUnwap = tdNodes{
                    for tdNode in tdNodesUnwap{
                        let contents : String = tdNode.contents
                        if(contents == "フォロワー数"){
                            trStartIndex = k+1
                        }
                    }
                }
                k++
            }
        }
        
        //アンラップについて
        //ref:http://qiita.com/cotrpepe/items/518c4476ca957a42f5f1
        
        //
        
        for i in 0..<50{
            if let trNodesUnwap = trNodes{
                let node0 : HTMLNode? = trNodesUnwap[trStartIndex+i]
                let tdNodes : Array<HTMLNode>? = node0?.findChildTags("td")
                
                if let tdNodesUnwap = tdNodes {
                    let rankingNumNode : HTMLNode? = tdNodesUnwap[0]
                    let nameNode : HTMLNode? = tdNodesUnwap[1].findChildTag("a")?.findChildTag("b")
                    let aNode : HTMLNode? = tdNodesUnwap[1].findChildTag("a")
                    let profileUrl = aNode?.getAttributeNamed("href")
                    let imgNode : HTMLNode? = tdNodesUnwap[1].findChildTag("img")
                    let imgUrl = imgNode?.getAttributeNamed("src")
                    let junreNode : HTMLNode? = tdNodesUnwap[2]
                    let followerNumNode : HTMLNode? = tdNodesUnwap[tdNodes!.count-1]
                    
                    
                    Log.DLog("\(rankingNumNode!.contents) \(nameNode!.contents) \(junreNode!.contents) \(followerNumNode!.contents)")
                    Log.DLog("url:\(imgUrl)")
                    Log.DLog("profile:\(profileUrl)")
                    
                    let ranking : Int! = rankingNumNode!.contents.toInt()
                    let followerRanking
                    = FollowerRanking(rankingNo: ranking, name: nameNode!.contents, junre: junreNode!.contents, followerString: followerNumNode!.contents,imageUrl:imgUrl,profileUrl:profileUrl)
                    
                    followerRankings.addObject(followerRanking)
                }
            }
        }
        
        return followerRankings
    }
    
//    class func convertTalentUserFromHtml(html:String="") -> TalentUser {
//        
//        
//    }
    
}