//
//  FollowerRanking.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/05/31.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class FollwerRanking {
    
    var rankingNo : Int
    var name : String
    var junre : String
    var follower : String
    
    init(rankingNo:Int=0 ,name:String="" , junre:String="",follower:String=""){
        self.rankingNo = rankingNo
        self.name = name
        self.junre = junre
        self.follower = follower
    }
    
}