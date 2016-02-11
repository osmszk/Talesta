//
//  AppDelegate.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/05/13.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
//import CoreData
//import SugarRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tracker: GAITracker?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if Const.ENABLE_AD{
            setupAds()
        }
        
        if Const.ENABLE_ANALYTICS{
            GAI.sharedInstance().trackUncaughtExceptions = true;
            GAI.sharedInstance().dispatchInterval = 20
            GAI.sharedInstance().logger.logLevel = .Verbose
            if let _ = UIApplication.sharedApplication().delegate as? AppDelegate {
                self.tracker = GAI.sharedInstance().trackerWithTrackingId(Const.GOOGLE_ANALYTICS_TRACKING_ID)
            }
        }
        
        self.customizeColor()
        
        let tab: TabBarController = TabBarController()
        
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let storyboard2 = UIStoryboard(name: "Main2", bundle: nil)
        let top = storyboard1.instantiateViewControllerWithIdentifier("top") as! TopViewController
        let followerRank  = storyboard1.instantiateViewControllerWithIdentifier("followerranking") as! FollowerRankingViewController
        let search = storyboard1.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        let likeRank = storyboard2.instantiateViewControllerWithIdentifier("likeranking") as! LikeRankingViewController
        let news = storyboard1.instantiateViewControllerWithIdentifier("news") as! NewsViewController
        
        let navi0:UINavigationController = UINavigationController(rootViewController:top)
        let navi1:UINavigationController = UINavigationController(rootViewController:search)
        let navi2:UINavigationController = UINavigationController(rootViewController:followerRank)
        let navi3:UINavigationController = UINavigationController(rootViewController:likeRank)
        let navi4:UINavigationController = UINavigationController(rootViewController:news)
        let naviControllerList:Array<UINavigationController> =
        [
            navi0,
            navi1,
            navi2,
            navi3,
            navi4
        ]
        tab.setViewControllers(naviControllerList, animated: true)
        if let items = tab.tabBar.items {
            (items[0] ).title = "トップ"
            (items[1] ).title = "芸能人検索"
            (items[2] ).title = "ﾌｫﾛﾜｰﾗﾝｷﾝｸﾞ"
            (items[3] ).title = "LIKEﾗﾝｷﾝｸﾞ"
            (items[4] ).title = "ニュース"
        }
        if let items = tab.tabBar.items {
            (items[0] ).image = UIImage(named: "tabbtn_t")
            (items[1] ).image = UIImage(named: "tabbtn_finduser")
            (items[2] ).image = UIImage(named: "tabbtn_group")
            (items[3] ).image = UIImage(named: "tabbtn_like")
            (items[4] ).image = UIImage(named: "tabbtn_news")
        }
        
        self.window!.rootViewController = tab
        self.window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func customizeColor(){
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        //info.plistで”View controller-based status bar”をNOにしておく必要がある。
        //LightContent->白
        
        UISegmentedControl.appearance().tintColor = Const.APP_COLOR1
        
        UINavigationBar.appearance().barTintColor = Const.APP_COLOR1//背景塗りつぶし色
        UINavigationBar.appearance().tintColor = Const.APP_COLOR8//ボタンのテキストカラー
        UINavigationBar.appearance().titleTextAttributes =  [NSForegroundColorAttributeName:Const.APP_COLOR8]
        //[NSObject : AnyObject]//タイトルの文字カラー
        
        UIToolbar.appearance().barTintColor = Const.APP_COLOR8//背景ぬりつぶし色
        UIToolbar.appearance().tintColor = Const.APP_COLOR1//ボタンのテキストカラー
        
        UITabBar.appearance().barTintColor = Const.APP_COLOR1//背景ぬりつぶし色
        UITabBar.appearance().tintColor = Const.APP_COLOR8//アイコンの線の色
        let font = UIFont.boldSystemFontOfSize(10)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:Const.APP_COLOR8,NSFontAttributeName:font], forState: UIControlState.Selected)//選択中のテキストカラー
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:font], forState: UIControlState.Normal)//通常時のテキストカラー
//        //http://qiita.com/yimajo/items/a7ed557d382077498181

    }
    
    func setupAds(){
        //banner
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_BANNER1)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER1)
        
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_BANNER2)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER2)
        
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_BANNER3)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER3)
        
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_BANNER4)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER4)
        
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_BANNER5)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER5)
        
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_NATIVE_LIST)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_NATIVE_LIST)
        
        //text
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID, mediaID:Const.AD_IMOBILE_MEDIA_ID, spotID:Const.AD_IMOBILE_SPOT_ID_TEXT)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_TEXT)
        
        //nakatsuka
        ImobileSdkAds.registerWithPublisherID(Const.AD_IMOBILE_PUBLISHER_ID_NAKA, mediaID:Const.AD_IMOBILE_MEDIA_ID_NAKA, spotID:Const.AD_IMOBILE_SPOT_ID_BANNER_NAKA)
        ImobileSdkAds.startBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER_NAKA)
    }
}

