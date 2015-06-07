//
//  FollowerRanking.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/05/31.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class FollowerRanking {
    
    var rankingNo : Int
    var name : String? //芸名 Talentinstaで使っている名前
    var junre : String?
    var follower : Int?
    var followerString : String?//コンマ区切り
    var imageUrl : String?
    var profileUrl : String?//Talentinstaの詳細URL
    
    init(rankingNo:Int=0 ,name:String="" , junre:String="",followerString:String="",imageUrl:String?,profileUrl:String?){
        self.rankingNo = rankingNo
        self.name = name
        self.junre = junre
        
        var followerStr : String = followerString.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
        
        self.follower = followerStr.toInt()
        self.followerString = followerString
        self.imageUrl = imageUrl
        self.profileUrl = profileUrl
    }
    
}