//
//  PLCommon.h
//  KurakuraTube
//
//  Created by Osamu Suzuki on 2015/01/05.
//  Copyright (c) 2014年 Plegineer, Inc. All rights reserved.
//

#ifdef DEBUG
#  define DEBUGLOG(...) NSLog(__VA_ARGS__)
#  define LOG_CURRENT_METHOD NSLog(@"[%@] # %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#  define DEBUGLOG(...) ;
#  define LOG_CURRENT_METHOD ;
#endif

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//TODO:申請時
//サーバーのversion.jsonのバージョンを現状AppStoreに公開されてるバージョン(初の場合は0.0.0)にする。フラグも1にする。

//TODO:申請とおったら
//サーバーのversion.jsonのバージョンを現状AppStoreに公開されてるバージョン(初の場合は1.0.0)にする。フラグも0にする。

#define URL_APP_STORE       @"https://itunes.apple.com/jp/app/id984976478?mt=8"

#define URL_SUPPORT_TWITTER    @"https://mobile.twitter.com/s_0samu"
#define SUPPORT_MAIL           @"app+kurakuratube@suzukicreative.com"
#define URL_APP_STORE_OYAJINEK @"https://itunes.apple.com/jp/app/id904134254?mt=8"
#define URL_APP_STORE_UNLOCKER @"https://itunes.apple.com/jp/app/id875225343?mt=8"
#define URL_APP_STORE_MEMO     @"https://itunes.apple.com/jp/app/id896419388?mt=8"
#define URL_APP_STORE_CALENDER @"https://itunes.apple.com/jp/app/id908861866?mt=8"
#define URL_APP_STORE_MESSAGE  @"https://itunes.apple.com/jp/app/id931812704?mt=8"
#define URL_APP_STORE_NATSUMEL @"https://itunes.apple.com/jp/app/id938517576?mt=8"
#define URL_APP_STORE_PICTUNES @"https://itunes.apple.com/jp/app/id876866172?mt=8"
#define URL_APP_STORE_KAKUREIC @"https://itunes.apple.com/jp/app/id404832410?mt=8"
#define URL_APP_STORE_SKISNOWB @"https://itunes.apple.com/jp/app/id955361333?mt=8"
#define URL_APP_STORE_BASKETFD @"https://itunes.apple.com/jp/app/id977144940?mt=8"
#define URL_APP_STORE_ALL      @"http://appstore.com/suzukicreative"

#define URL_REVIEW_API @"http://plegineer.co.jp/api/kurakuratube/version.json"

//i-mobile(CoreLocation,AdSupport,SystemConfig)
#define AD_IMOBILE_PUBLISHER_ID   @"29411"
#define AD_IMOBILE_MEDIA_ID       @"164313"
#define AD_IMOBILE_SPOT_ID_BANNER_1 @"436147"//tabbar
#define AD_IMOBILE_SPOT_ID_BANNER_2 @"436146"//videoview
#define AD_IMOBILE_SPOT_ID_ICON_1   @"436148"//videoview 1 :account pos
#define AD_IMOBILE_SPOT_ID_ICON_2   @"436150"//videoview 2 :under pos
#define AD_IMOBILE_SPOT_ID_INT  @"436151"

//40degreeのやーつ
//#define AD_IMOBILE_PUBLISHER_ID @"29411"
//#define AD_IMOBILE_MEDIA_ID     @"106566"
//#define AD_IMOBILE_SPOT_ID_INT  @"243725"//インタースティシャル
//#define AD_IMOBILE_SPOT_ID_BANNER1 @"243706"//バナー
//#define AD_IMOBILE_SPOT_ID_ICON   @"252517"

//NEND(AdSupport,Security,ImageIO)
////$(SRCROOT)/$(PRODUCT_NAME)/NendAd-Bridging-Header.h
#define AD_NEND_APIKEY_INT           @"46c59324fe43d272d94db43fe8142f02978b7719"
#define AD_NEND_SPOTID_INT           @"365564"


//Admob(AdSupport,AudioToolbox,AVFoundation,CoreGraphics,CoreTelephony,EventKit,EventKitUI,MessageUI,StoreKit,SystemConfiguration "-ObjC")
//#define AD_ADMOB_UNIT_ID_BANNER_1 @"ca-app-pub-6784237840620329/3957771294"

//AppliPromotion wallAD(AdSupport,AVFoundation,libsqlite3.0.dylib "-all_load -ObjC") AMoAdSettings.txtも。
#define AD_APPLIPROMOTION_ID @"5MD8PZPCPVJHP73B"

//AmoAd (ImageIO,AdSupport "-ObjC")
#define AD_AMOAD_SID_0 @"62056d310111552c79b593da0b15f60d38c9718639d8cfe367d35077d365af1b"
#define AD_AMOAD_SID_1 @"62056d310111552c79b593da0b15f60dfa147a48d5879c65d752625903049383"
#define AD_AMOAD_SID_2 @"62056d310111552c79b593da0b15f60d581ee4d84a763655a72185d927627eb5"
#define AD_AMOAD_SID_3 @"62056d310111552c79b593da0b15f60d01f648c67def8d2b3c23e094110ee747"

//TODO:GoogleAnalyics v3.0.0(SystemConfig,Coredata,libz)
#define GOOGLE_ANALYTICS_TRACKING_ID @"UA-61843802-1"

#define HASH_TAG @"#InstaSearch"

//TODO: 申請前に1にする
#define ENABLE_ANALYTICS 1
//TODO: 申請前に1にする
#define ENABLE_AD 1
//TODO: 申請前に、ウォール型広告のdebugフラグとIDを、AMoAdSettings.txtで確認する

#define APP_NAME @"InstaSearch"

#define KEY_WALL_AD_SHOW_FLG     @"keyWallAdShowFlg"//FLG:YES = NOT in review
#define KEY_REVIEW_DONE_FLG      @"keyReviewDoneFlg"//レビュー催促→インセンティブ制限　が解除されたフラグ
#define KEY_FAVORITE_LIST @"keyFavoriteList"
#define KEY_VIDEO_COUNT @"keyVideoCount"//20,30,40,50
#define KEY_ENABLE_CHANGE_VIDEO_COUNT_FLG @"keyChangeVideoCountFlg"



#define APP_COLOR1 HEXCOLOR(0x730c24)//濃い赤
#define APP_COLOR2 HEXCOLOR(0xCC6600)//オレンジ
#define APP_COLOR3 HEXCOLOR(0x945200)//こげちゃいろ
#define APP_COLOR4 HEXCOLOR(0x770c02)//赤こげちゃ
#define APP_COLOR5 HEXCOLOR(0x6a3900)//こげちゃこいめ
#define APP_COLOR6 HEXCOLOR(0x2980b9)//濃い水色
#define APP_COLOR7 HEXCOLOR(0x00408d)//iconの青
#define APP_COLOR8 HEXCOLOR(0xfdda59)//金色


static BOOL const  NAVI_BAR_TRANSLUCENT = NO; //translucent
static CGFloat const AD_BANNER_HIGHT = 50.0f;
static CGFloat const AD_ICON_W = 50.0f;
static CGFloat const TAB_H = 49.0f;
static CGFloat const TABLE_VIEW_FOOTER_HEIGHT = 50.0f;
static CGFloat const TIME_OUT_INTERVAL = 10.0f;
#define API_YOUTUBE_KEY @"AIzaSyAEUijSNYxVgVwI6Xpkp9cw1l1wFL8azCA"

//ref: flv -> mp4??? Library
//https://wiki.videolan.org/VLCKit/



/*
 
 [mediation]
 http://nend.net/mediation/index
 https://developers.google.com/mobile-ads-sdk/docs/admob/mediation?hl=ja#ios
 https://developers.google.com/mobile-ads-sdk/docs/admob/fundamentals?hl=ja#ios
 https://support.google.com/admob/answer/3063564?hl=ja

 */

