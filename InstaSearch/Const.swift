//
//  Const.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/06.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class Const {
    
    //TODO: 申請前にtrueにする
    static let ENABLE_ANALYTICS = false
    //TODO: 申請前にtrueにする
    static let ENABLE_AD = true
    
    //TODO:申請時
    //サーバーのversion.jsonのバージョンを現状AppStoreに公開されてるバージョン(初の場合は0.0.0)にする。フラグも1にする。
    
    //TODO:申請とおったら
    //サーバーのversion.jsonのバージョンを現状AppStoreに公開されてるバージョン(初の場合は1.0.0)にする。フラグも0にする。
    
    static let URL_APP_STORE = "https://itunes.apple.com/jp/app/id1021240186?mt=8"
    static let URL_APP_STORE_SHORT = "http://apple.co/1fhAG4d"
    
    static let URL_SUPPORT_TWITTER    = "https://mobile.twitter.com/s_0samu"
    static let SUPPORT_MAIL           = "app+instasearch@suzukicreative.com"
    static let URL_APP_STORE_UNLOCKER = "https://itunes.apple.com/jp/app/id875225343?mt=8"
    static let URL_APP_STORE_MEMO     = "https://itunes.apple.com/jp/app/id896419388?mt=8"
    static let URL_APP_STORE_CALENDER = "https://itunes.apple.com/jp/app/id908861866?mt=8"
    static let URL_APP_STORE_MESSAGE  = "https://itunes.apple.com/jp/app/id931812704?mt=8"
    static let URL_APP_STORE_NATSUMEL = "https://itunes.apple.com/jp/app/id938517576?mt=8"
    static let URL_APP_STORE_PICTUNES = "https://itunes.apple.com/jp/app/id876866172?mt=8"
    static let URL_APP_STORE_KAKUREIC = "https://itunes.apple.com/jp/app/id404832410?mt=8"
    static let URL_APP_STORE_ALL      = "http://appstore.com/suzukicreative"

    static let URL_REVIEW_API = "http://plegineer.co.jp/api/talesta/version.json"
    
    //i-mobile(CoreLocation,AdSupport,SystemConfig)
    static let AD_IMOBILE_PUBLISHER_ID   = "29411"
    static let AD_IMOBILE_MEDIA_ID       = "191728"//test:101043
    static let AD_IMOBILE_SPOT_ID_BANNER1 = "531578"//バナー//test:243706//top
    static let AD_IMOBILE_SPOT_ID_BANNER2 = "531581"//search
    static let AD_IMOBILE_SPOT_ID_BANNER3 = "531582"//follower
    static let AD_IMOBILE_SPOT_ID_BANNER4 = "531583"//talent detail mideam rectangle
    static let AD_IMOBILE_SPOT_ID_BANNER5 = "531584"//web
    static let AD_IMOBILE_SPOT_ID_TEXT = "531585"//web
    static let AD_IMOBILE_SPOT_ID_NATIVE_LIST = "742228"//list
    
    //中司さんのアイモバアカウント
    static let AD_IMOBILE_PUBLISHER_ID_NAKA   = "42085"
    static let AD_IMOBILE_MEDIA_ID_NAKA       = "192049"
    static let AD_IMOBILE_SPOT_ID_BANNER_NAKA = "532508"
    
    //adcrops 8crops
    static let AD_ADCROPS_URL = "http://tibetanmastiff.link/talesta/"
    
    //amoad nativead
//    static let AD_AMOAD_SID_1 = "62056d310111552c79b593da0b15f60d01f648c67def8d2b3c23e094110ee747"
    
    //40degreeのやーつ
    //#define AD_IMOBILE_PUBLISHER_ID @"29411"
    //#define AD_IMOBILE_MEDIA_ID     @"106566"
    //#define AD_IMOBILE_SPOT_ID_INT  @"243725"//インタースティシャル
    //#define AD_IMOBILE_SPOT_ID_BANNER1 @"243706"//バナー
    //#define AD_IMOBILE_SPOT_ID_ICON   @"252517"
    
    //NEND(AdSupport,Security,ImageIO)
    
    //Admob(AdSupport,AudioToolbox,AVFoundation,CoreGraphics,CoreTelephony,EventKit,EventKitUI,MessageUI,StoreKit,SystemConfiguration "-ObjC")
//    static let AD_ADMOB_UNIT_ID_BANNER_1 = "ca-app-pub-6784237840620329/5409420894"
    
    //GoogleAnalyics v3.0.0(SystemConfig,Coredata,libz.dylib,libsqlite3.dylib)
    static let GOOGLE_ANALYTICS_TRACKING_ID = "UA-65312442-1"
    
    static let HASH_TAG = "#talesta"
    
    static let APP_NAME = "talesta"
    
    static let NAVI_BAR_TRANSLUCENT = false
    static let AD_BANNER_HIGHT = 50.0;
    static let AD_ICON_W = 50.0;
    static let TAB_H = 49.0;
    static let TABLE_VIEW_FOOTER_HEIGHT = 50.0;
    static let TIME_OUT_INTERVAL = 10.0;
    
    static let APP_COLOR8 = Util.hexColor("0xffffff")
    static let APP_COLOR2 = Util.hexColor("0x000000")
    static let APP_COLOR3 = Util.hexColor("0x000000")
    static let APP_COLOR4 = Util.hexColor("0xffffff")
    static let APP_COLOR1 = Util.hexColor("0x000000")
    
    static let KEY_START_DATE = "keyStartDate"
    static let KEY_WALL_AD_SHOW_FLG = "keyWallAdShowFlg"//FLG:YES = NOT in review
    static let KEY_REVIEW_DONE_FLG = "keyReviewDoneFlg"//レビュー催促→インセンティブ制限　が解除されたフラグ
    static let KEY_HIDE_LAST_CAMPAIGN_TYPE = "keyHideCampaignLastCampaignType"//最後に非表示ボタンおしたときのCampaignType
    
    static let URL_FOLLOWER_RANKING = "http://www.talentinsta.com/follower/99/";
    static let URL_LIKE_RANKING_JP = "http://websta.me/hot/jp_posts";
    static let URL_LIKE_RANKING_US = "http://websta.me/hot/posts";
    static let URL_RSS_NEWS_INSTA = "https://news.google.com/news?hl=ja&ned=us&ie=UTF-8&oe=UTF-8&output=rss&q=instagram"
    /*
    スマートフォンバナー広告 テストID
    
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135002
    スポットＩＤ　　: 342407
    
    スマートフォンビッグバナー広告 テストID
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135002
    スポットＩＤ　　: 342408
    
    ミディアムレクタングルバナー広告 テストID
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135002
    スポットＩＤ　　: 342409
    
    インタースティシャル広告 テストID
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135002
    スポットＩＤ　　: 342411
    
    テキストポップアップ広告 テストID
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135002
    スポットＩＤ　　: 342412
    
    バナー広告 テストID
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135180
    スポットＩＤ　　: 342421
    
    ビッグバナー広告 テストID
    パートナーＩＤ　: 34816
    メディアＩＤ　　: 135180
    スポットＩＤ　　: 342422
    */
    
}