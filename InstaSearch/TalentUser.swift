//
//  User.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/05.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class TalentUser {
    
    var usrId : NSString?//公式InstagramのID ex) becky_dayo
    var userName : NSString?//公式Instagramの表示名 ex) Becky ベッキー
    var talentInstaName : NSString?//talentinstaで使われている表示名＝芸名　ex)ベッキー
    var profile : NSString? //公式Instagramのプロフィール文 ex)ベッキーなのかもしれない！
    var postCount : Int?
    var followerCount : Int?
    var followingCount : Int?
    var officialUrl : String? //公式Instgramページ
    var iconImageUrl : String? //
    
    
   
}
