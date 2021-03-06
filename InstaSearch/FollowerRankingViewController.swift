
//  FollowerRankingViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class FollowerRankingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isReviewOver : Bool = false
    
    var followerRankings : NSMutableArray = NSMutableArray()
    var adBannerView : UIView?
    
    let INITIAL_ROW_NUM_MAX : Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "フォロワーランキング"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        let reloadButton = UIButton(type: UIButtonType.Custom)
        reloadButton.frame = CGRectMake(0, 0, 34, 34);
        reloadButton.setImage(UIImage(named: "barbtn_reload_white"), forState: UIControlState.Normal)
        reloadButton.addTarget(self, action: #selector(FollowerRankingViewController.pushedReloadButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reloadButton)
        
        showBannerAd()
        
        self.isReviewOver = Util.loadBool(Const.KEY_WALL_AD_SHOW_FLG)
        
        SVProgressHUD.show()
        self.requestToGetRanking()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
        if segue.identifier == "followerraking_to_detail"{
            let controller = segue.destinationViewController as! UserDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let row = indexPath?.row
            
            let followerRanking = self.followerRankings[row!] as! Talentinsta
            controller.followerRanking = followerRanking
        }
    }
    
    // MARK: - Methods
    
    func pushedReloadButton(sender:UIButton){
        self.followerRankings.removeAllObjects()
        self.tableView.reloadData()
        
        SVProgressHUD.show()
        self.requestToGetRanking()
    }
    
    func requestToGetRanking(){
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = Const.URL_FOLLOWER_RANKING
        manager.GET(url,
            parameters: nil,
            timeoutInterval: 10,
            success: { (operation : AFHTTPRequestOperation!, responsobject: AnyObject!) -> Void in
                //クロージャ
                //ref:http://ja.wikipedia.org/wiki/Swift_%28%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E%29#.E3.82.AF.E3.83.AD.E3.83.BC.E3.82.B8.E3.83.A3
                
                SVProgressHUD.dismiss()
                
                //ref:http://blog.f60k.com/objective-c%E3%81%A8swift%E3%81%AE%E7%B5%84%E3%81%BF%E5%90%88%E3%82%8F%E3%81%9B%E6%96%B9%E3%81%AE%E3%81%BE%E3%81%A8%E3%82%81/
                Log.DLog("success")
                
                let html : NSString? = NSString(data: responsobject as! NSData, encoding: NSJapaneseEUCStringEncoding)
                if html == nil {
                    let utf8 : NSString? = NSString(data: responsobject as! NSData, encoding: NSUTF8StringEncoding)
                    Log.DLog("failed! :\(utf8)")
                    return
                }
                
                let followerRankings = ParseHelper.convertFollowerRankingFromHtml(html! as String)
                
                self.followerRankings.addObjectsFromArray(followerRankings as Array)
                
                self.tableView.reloadData()
                
            },
            failure: {( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.showErrorWithStatus("情報取得に失敗しました")
                Log.DLog("error \(error)")
                Log.DLog("error \(error.localizedDescription)")
        })
        
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.followerRankings.count==0{
            return 0
        }else{
            if self.isReviewOver && !Util.loadBool(Const.KEY_REVIEW_DONE_FLG){
                return INITIAL_ROW_NUM_MAX + 1
            }else{
                return self.followerRankings.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.isReviewOver && !Util.loadBool(Const.KEY_REVIEW_DONE_FLG){
            if indexPath.row == INITIAL_ROW_NUM_MAX{
                let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath) 
                return cell
            }
        }
        let cell  = tableView.dequeueReusableCellWithIdentifier("followerRankingCell", forIndexPath: indexPath) as! FollowerRankingTableViewCell
        //UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "followerRankingCell") as! FollowerRankingTableViewCell
        
        let ranking = self.followerRankings[indexPath.row] as! Talentinsta
        cell.nameLabel?.text = ranking.name
        cell.rankingLabel?.text = NSString(format: "%d", ranking.rankingNo) as String
        if ranking.imageUrl != nil {
            let url = ranking.imageUrl
            let placeImage = UIImage(named: "loading")
            cell.iconImageView.setImageWithURL(NSURL(string:url!), placeholderImage: placeImage)
            //インスタ画像の大きさは150x150
        }
        cell.iconImageView.layer.cornerRadius = 75.0 * 0.5
        cell.iconImageView.clipsToBounds = true
        
        cell.followerNumLabel?.text = ranking.followerString
        cell.categoryLabel?.text = ranking.junre
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Util.displaySize().width/CGFloat(320.0) * CGFloat(Const.AD_BANNER_HIGHT)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.isReviewOver && !Util.loadBool(Const.KEY_REVIEW_DONE_FLG){
            if indexPath.row == INITIAL_ROW_NUM_MAX{
                
                let alertController = UIAlertController(title: "", message: "このアプリの良さをレビューで伝えて頂いた方に、「21位以降見れる機能」をプレゼント!\n星5つだと制作者として、とっても励みになります^^\n", preferredStyle: .Alert)
                
                let otherAction = UIAlertAction(title: "レビューする", style: .Cancel) { action in
                    
                    let url = NSURL(string: Const.URL_APP_STORE)!
                    UIApplication.sharedApplication().openURL(url)
                    
                    Util.saveBool(true,forKey:Const.KEY_REVIEW_DONE_FLG)
                    
                    self.tableView.reloadData()

                }
                let laterAction = UIAlertAction(title: "あとで", style: .Default) {action in
                    
                }
                alertController.addAction(otherAction)
                alertController.addAction(laterAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func jumpToDetail(){
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let detail  = storyboard1.instantiateViewControllerWithIdentifier("detail") as! UserDetailViewController
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
