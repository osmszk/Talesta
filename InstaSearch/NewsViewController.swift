//
//  NewsViewController.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/08/08.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var newsModels : [News] = []
    var adBannerView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        SVProgressHUD.show()
        self.requestToGetNews()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let row = self.tableView.indexPathForSelectedRow(){
            self.tableView.deselectRowAtIndexPath(row, animated: true)
        }
    }

    
    //MARK: Custom Methods
    
    func showBannerAd(){
        let w = Util.displaySize().width
        let h = Util.displaySize().width/CGFloat(320.0) * CGFloat(Const.AD_BANNER_HIGHT)
        let x = CGFloat(0.0)
        let y = Util.displaySize().height-h-CGFloat(Const.TAB_H+44.0+20.0)
        let adView = UIView(frame: CGRectMake(x, y, w, h))
        adView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(adView)
        self.adBannerView = adView;
        
        ImobileSdkAds.showBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER3, view: self.adBannerView, sizeAdjust: true)
    }
    
    func requestToGetNews(){
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = Const.URL_RSS_NEWS_INSTA
        manager.GET(url,
            parameters: nil,
            timeoutInterval: 10,
            success: { (operation : AFHTTPRequestOperation!, responsobject: AnyObject!) -> Void in
                
                SVProgressHUD.dismiss()
                Log.DLog("success")
                
                let html : NSString? = NSString(data: responsobject as! NSData, encoding: NSUTF8StringEncoding)
                if html == nil {
                    Log.DLog("failed!")
                    return
                }
                Log.DLog("html:\(html)")
                
                
                
                self.tableView.reloadData()
                
            },
            failure: {( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.showErrorWithStatus("情報取得に失敗しました")
                Log.DLog("error \(error)")
                Log.DLog("error \(error.localizedDescription)")
        })
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "news_to_web"{
            let webController = segue.destinationViewController as! WebViewController
            
            let cell = sender as! NewsTableViewCell
            let indexPath = self.tableView.indexPathForSelectedRow()
            let row = indexPath?.row
            
//            if let models = self.newsModels {
//                let talent = models[row!] as News
//                webController.urlStr = talent.url
//                
//                webController.mode = JOWebBrowserMode.Navigation
//                webController.showURLStringOnActionSheetTitle = false
//                webController.showPageTitleOnTitleBar = true
//                webController.showReloadButton = true
//                webController.showActionButton = true
//            }
        }
    }
    
    //MARK: UITableViewDataSource
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsModels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! NewsTableViewCell
        
        let news = self.newsModels[indexPath.row] as News
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Util.displaySize().width/CGFloat(320.0) * CGFloat(Const.AD_BANNER_HIGHT)
    }
    
    

}
