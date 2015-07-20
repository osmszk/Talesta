//
//  Const.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/06.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class Const {
    
    //TODO:申請時
    //サーバーのversion.jsonのバージョンを現状AppStoreに公開されてるバージョン(初の場合は0.0.0)にする。フラグも1にする。
    
    //TODO:申請とおったら
    //サーバーのversion.jsonのバージョンを現状AppStoreに公開されてるバージョン(初の場合は1.0.0)にする。フラグも0にする。
    
    //TODO:URL修正
    static let URL_APP_STORE = "https://itunes.apple.com/jp/app/id938517576?mt=8"
    static let URL_APP_STORE_SHORT = "http://bit.ly/natsu_"
    
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

    static let URL_REVIEW_API = "http://plegineer.co.jp/api/instasearch/version.json"
    
    //TODO:
    //i-mobile(CoreLocation,AdSupport,SystemConfig)
    static let AD_IMOBILE_PUBLISHER_ID   = "29411"
    static let AD_IMOBILE_MEDIA_ID       = "129311"//test:101043
    static let AD_IMOBILE_SPOT_ID_BANNER = "322000"//バナー//test:238097//med
    static let AD_IMOBILE_SPOT_ID_BANNER2 = "385340"//セル間
    static let AD_IMOBILE_SPOT_ID_ICON    = "385295"
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
    
    //TODO: 申請前にtrueにする
    static let ENABLE_ANALYTICS = false
    //TODO: 申請前にtrueにする
    static let ENABLE_AD = true
    
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
    
    //TODO:その他画面
    
    //TODO:アナリティクス
    //TODO:広告
    
    //TODO:tabアイコン
    
    
}