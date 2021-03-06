//
//  NewsViewController.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/08/08.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

protocol NewsViewControllerDelegate:class{
    func newsFinish(viewControllr:NewsViewController)
}

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MWFeedParserDelegate {

    @IBOutlet weak var tableView: UITableView!
    var imobileSdkAdsTableController : ImobileSdkAdsTableController!

    var items :[MWFeedItem] = []
    var adBannerView : UIView?
    weak var delegate : NewsViewControllerDelegate? = nil
    var tableArray : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        self.navigationItem.title = "インスタニュース"
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.Plain, target: self, action: "pushedCloseButton")
        
        showBannerAd()
        showNativeListAd()
        
        if !Util.isOnline() {
            SVProgressHUD.showErrorWithStatus("Network Error")
            return
        }
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
        //0.5秒遅らせて実行
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.requestToGetNews()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Const.ENABLE_ANALYTICS{
            let build = GAIDictionaryBuilder.createScreenView().set(theClassName, forKey: kGAIScreenName).build() as NSDictionary
            GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let row = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRowAtIndexPath(row, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }

    
    //MARK: Custom Methods
    
    func showNativeListAd(){
        if Const.ENABLE_AD {
            imobileSdkAdsTableController = ImobileSdkAds.getTableController(Const.AD_IMOBILE_SPOT_ID_NATIVE_LIST, tableView: self.tableView, nib: UINib(nibName: "AdCellLayout", bundle: nil))
        }
    }
    
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
    
    func requestToGetNews() {
        let URL = NSURL(string: Const.URL_RSS_NEWS_INSTA)
        let feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.parse()
    }
    
    //Action: - Action
    func pushedCloseButton(){
        self.delegate?.newsFinish(self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "news_to_web"{
            let webController = segue.destinationViewController as! WebViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let row = imobileSdkAdsTableController.getOriginalCellPostion(indexPath!)
            
            let talent = self.items[row] as MWFeedItem
            webController.urlStr = talent.link
            
            webController.mode = JOWebBrowserMode.Navigation
            webController.showURLStringOnActionSheetTitle = false
            webController.showPageTitleOnTitleBar = true
            webController.showReloadButton = true
            webController.showActionButton = true
        }
    }
    
    
    //MARK: UITableViewDataSource
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! NewsTableViewCell
        let item = self.items[indexPath.row]
        let itemTitle = item.title as NSString
        let itemTitles = itemTitle.componentsSeparatedByString("-")
        let articleTitle = itemTitles[0] 
        cell.titleLabel.text = articleTitle
        if itemTitles.count >= 1{
            cell.sourceLabel.text = itemTitles[itemTitles.count-1]
        }else{
            cell.sourceLabel.text = ""
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        cell.dateLabel.text = formatter.stringFromDate(item.date) as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Util.displaySize().width/CGFloat(320.0) * CGFloat(Const.AD_BANNER_HIGHT)
    }
    
    //MARK: MWFeedParserDelegate
    
    func feedParserDidStart(parser: MWFeedParser) {
        SVProgressHUD.show()
        self.items = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.items.sortInPlace { (lItem, rItem) -> Bool in
            //ref:http://qiita.com/mst/items/b18e9531ac0cbdf2f3c3
            return lItem.date.timeIntervalSinceDate(rItem.date)>0
        }
        
    
        self.tableArray = self.items    
        
        self.tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
#if DEBUG
        print(info)
#endif
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
#if DEBUG
        print(item)
#endif
        self.items.append(item)
        
//        SVProgressHUD.showErrorWithStatus("情報取得に失敗しました")
//        Log.DLog("error \(error)")
//        Log.DLog("error \(error.localizedDescription)")
    }
    
    

}
