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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        let tab: TabBarController = TabBarController()
        
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let storyboard2 = UIStoryboard(name: "Main2", bundle: nil)
        var top = storyboard1.instantiateViewControllerWithIdentifier("top") as! TopViewController
        var followerRank  = storyboard1.instantiateViewControllerWithIdentifier("followerranking") as! FollowerRankingViewController
        var search = storyboard1.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        var likeRank = storyboard2.instantiateViewControllerWithIdentifier("likeranking") as! LikeRankingViewController
        var other = storyboard1.instantiateViewControllerWithIdentifier("other") as! OtherViewController
        
        var navi0:UINavigationController = UINavigationController(rootViewController:top)
        var navi1:UINavigationController = UINavigationController(rootViewController:search)
        var navi2:UINavigationController = UINavigationController(rootViewController:followerRank)
        var navi3:UINavigationController = UINavigationController(rootViewController:likeRank)
        var navi4:UINavigationController = UINavigationController(rootViewController:other)
        var naviControllerList:Array<UINavigationController> =
        [
            navi0,
            navi1,
            navi2,
            navi3,
            navi4
        ]
        
        tab.setViewControllers(naviControllerList, animated: true)
        if let items = tab.tabBar.items {
            (items[0] as! UITabBarItem).title = "トップ"
            (items[1] as! UITabBarItem).title = "芸能人検索"
            (items[2] as! UITabBarItem).title = "ﾌｫﾛﾜｰﾗﾝｷﾝｸﾞ"
            (items[3] as! UITabBarItem).title = "LIKEﾗﾝｷﾝｸﾞ"
            (items[4] as! UITabBarItem).title = "その他"
        }
        
        self.window!.rootViewController = tab
        self.window!.makeKeyAndVisible()
        
        SVProgressHUD.showWithStatus("データ読込中", maskType: SVProgressHUDMaskType.Gradient)
        dispatch_async_global {
            //重い処理
            self.setupDatabase();
            self.dispatch_async_main {
                // ここからメインスレッド
                SVProgressHUD.dismiss()
                //UIいじる
            }
        }
        
        return true
    }
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    func setupDatabase(){
//        RealmHelper.deleteAll()
        
        
        RealmHelper.makeRealmModelIfNeeded()
        RealmHelper.makeTerraceHouseRealmModelIfNeeded()
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


}

