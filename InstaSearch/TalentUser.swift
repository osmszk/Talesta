//
//  User.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/05.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class TalentUser {
    
    
    var userId : String?         //公式InstagramのuserID ex) 458698449
    var userName : String?       //公式InstagramのuserName ex) becky_dayo
    var name : String?           //公式Instagramの表示名 ex) Becky ベッキー
    var talentInstaName : String?//talentinstaで使われている表示名＝芸名　ex)ベッキー
    var profile : String?        //公式Instagramのプロフィール文 ex)ベッキーなのかもしれない！
    var postCount : Int?
    var followerCount : Int?
    var followingCount : Int?
    var officialUrl : String?    //公式Instgramページ ex)https://instagram.com/becky_dayo/
    var iconImageUrl : String?   //talentinstaのアイコン画像URL
    var wedgetUrl : String?      //talentinstaのwidget(websta)URL ex)http://websta.me/n/becky_dayo
    
    
   
}
