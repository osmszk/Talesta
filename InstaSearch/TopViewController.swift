//
//  TopViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import RealmSwift

enum CampaignType: Int {
    case TerraceHouse = 0
    case Singer = 1
    case TalentWoman = 2
    case International = 3
    case ModelAndBikini = 4
    case TalentMan = 5
    case KoreanIdol = 6
    case AkbGroup = 7
    case Comedian = 8
    case Creator = 9
    
    func guides() ->[String]{
        switch self{
        case .TerraceHouse: return ["テラスハウス特集！","テラスハウスの出演者たちのインスタグラムを今すぐチェックしよう！"]
        case .Singer:       return ["アーティスト(歌手)特集！","アーティスト(歌手)の出演者たちのインスタグラムを今すぐチェックしよう！"]
        case .TalentWoman:  return ["女性タレント特集！","女性タレントのインスタグラムを今すぐチェックしよう！"]
        case .International: return ["海外セレブ特集！","海外セレブのインスタグラムを今すぐチェックしよう！"]
        case .ModelAndBikini: return ["モデル/グラビア特集！","モデル/グラビアのインスタグラムを今すぐチェックしよう！"]
        case .TalentMan:    return ["男性タレント特集！","男性タレントのインスタグラムを今すぐチェックしよう！"]
        case .KoreanIdol:   return ["韓国アイドル特集！","韓国アイドルのインスタグラムを今すぐチェックしよう！"]
        case .AkbGroup:     return ["AKBグループ特集！","AKBグループのインスタグラムを今すぐチェックしよう！"]
        case .Comedian:     return ["芸人特集！","芸人のインスタグラムを今すぐチェックしよう！"]
        case .Creator:      return ["クリエイター+α特集！","クリエイター+αのインスタグラムを今すぐチェックしよう！"]
        }
    }
}

class TopViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guideView: UIView!
    @IBOutlet weak var guideCloseButton: UIButton!
    @IBOutlet weak var guideTitleLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    
    @IBOutlet weak var guideViewHeightConstraint: NSLayoutConstraint!
    
    var talentModels : Results<SubTalentModel>? = nil
    var adBannerView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "logo_white"))
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        var type = self.campaignTypeSaved()
        var guide : [String] = CampaignType.guides(type)()
        
        self.guideTitleLabel.text = guide[0]
        self.guideLabel.text = guide[1]
        
        self.talentModels = RealmHelper.subModelAll(type)
        
        if let models = self.talentModels{
            if models.count == 0 {
                SVProgressHUD.showWithStatus("データ読込中", maskType: SVProgressHUDMaskType.Gradient)
                dispatch_async_global {
                    //重い処理
                    self.setupDatabase();
                    self.dispatch_async_main {
                        // ここからメインスレッド
                        SVProgressHUD.dismiss()
                        //UIいじる
                        
                        self.talentModels = RealmHelper.subModelAll(type)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        showBannerAd()
        
        let appversionState = Util.appVersionState()
        if (appversionState == Util.AppVersionState.First || appversionState == Util.AppVersionState.BumpedUp) {
            //サーバーチェック
            Log.DLog("first or bumpedUp!");
            self.startServerCheckAf()
            return
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Const.ENABLE_ANALYTICS{
             let screenName = reflect(self).summary
            let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary
            GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let row = self.tableView.indexPathForSelectedRow(){
            self.tableView.deselectRowAtIndexPath(row, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    @IBAction func pushedCloseButton(sender: AnyObject) {
        
        self.guideViewHeightConstraint.constant = 0;
        self.guideLabel.hidden = true
        self.guideTitleLabel.hidden = true
        UIView.animateWithDuration(0.6) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Private Methods
    
    func startServerCheckAf(){
        if(!Util.isOnline()){
            return
        }
        
        self.removeCache()
        
        SVProgressHUD.showWithStatus("", maskType: SVProgressHUDMaskType.Clear)
        self.requestToCheckForReviewAf()
    }
    
    func removeCache(){
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    func requestToCheckForReviewAf(){
        let url = Const.URL_REVIEW_API
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as Set<NSObject>
        manager.GET(url, parameters:nil,timeoutInterval:3.0, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            
            SVProgressHUD.dismiss()
            Util.saveTrackingAppVersion()
            Log.DLog("responseObject:\(responseObject)")
            
            let jsonDic    = responseObject as? NSDictionary;//[request responseString];
            //        DEBUGLOG(@"jsonDic:%@",jsonDic);
            let shouldNOWallAd = self.shouldBeNoWallAd(jsonDic)
            
            if (shouldNOWallAd){
                Util.saveBool(false,forKey:Const.KEY_WALL_AD_SHOW_FLG)
            }else{
                Util.saveBool(true,forKey:Const.KEY_WALL_AD_SHOW_FLG)
            }
        },failure:{ (operation:AFHTTPRequestOperation! , error:NSError!) -> Void in
            Log.DLog("error!!!")
            println(operation.responseObject);
            SVProgressHUD.dismiss()
        })
    }
    
    func shouldBeNoWallAd(response: NSDictionary?) -> Bool{
        if let responseDic = response{
            let thisAppVer = Util.appVersionNumber().floatValue
            let appVersionString: String = responseDic["version"] as! String
            let serverVer = Util.convertToNumberVersion(appVersionString).floatValue
            Log.DLog("sever:\(serverVer) app:\(thisAppVer)")
            let flgInt = responseDic["flg"] as! Int
            let isInReview : Bool = flgInt == 1
            if(thisAppVer > serverVer && isInReview){
                return true;
            }
            return false;
        }
        return false
    }
    
    func setupDatabase(){
        //        RealmHelper.deleteAll()
        RealmHelper.makeRealmModelIfNeeded()
        
        for i : Int in 0...9{
            if RealmHelper.subModelAll(CampaignType(rawValue: i)!).count==0{
                RealmHelper.makeSubRealmModel(CampaignType(rawValue: i)!)
            }
        }
    }
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
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
        
        ImobileSdkAds.showBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER1, view: self.adBannerView, sizeAdjust: true)
    }
    
    func campaignTypeSaved()->CampaignType{
        var date = Util.loadObject(Const.KEY_START_DATE) as? NSDate
        if date == nil{
            Util.saveObject(NSDate(), forKey: Const.KEY_START_DATE)
            return CampaignType.TerraceHouse
        }
        //test
        //        date = NSDate(timeIntervalSinceNow: -1*24*60*60)//singer
        //        date = NSDate(timeIntervalSinceNow: -2*24*60*60)//talentwoman
        //        date = NSDate(timeIntervalSinceNow: -3*24*60*60)//international
        //        date = NSDate(timeIntervalSinceNow: -4*24*60*60)//model
        //        date = NSDate(timeIntervalSinceNow: -5*24*60*60)//talentman
        //        date = NSDate(timeIntervalSinceNow: -6*24*60*60)//korean
        //        date = NSDate(timeIntervalSinceNow: -7*24*60*60)//akb
        //        date = NSDate(timeIntervalSinceNow: -8*24*60*60)//comedian
        //        date = NSDate(timeIntervalSinceNow: -9*24*60*60)//creator
        //        date = NSDate(timeIntervalSinceNow: -10*24*60*60)//terracehouse
        //        date = NSDate(timeIntervalSinceNow: -11*24*60*60)//singer
        
        let intervalSec = NSDate().timeIntervalSinceDate(date!)
        let fl = floor(intervalSec/(60*60*24))
        let s = Int(fl)
        let mod = s%10
        Log.DLog("interval \(intervalSec) fl \(fl) s \(s) mod \(mod)")
        let type = CampaignType(rawValue: mod)!
        return type
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "top_to_web"{
            let webController = segue.destinationViewController as! WebViewController
            
            let cell = sender as! TopTableViewCell
            let indexPath = self.tableView.indexPathForSelectedRow()
            let row = indexPath?.row
            
            if let models = self.talentModels {
                let talent = models[row!] as SubTalentModel
                webController.urlStr = talent.officialUrl
                
                webController.mode = JOWebBrowserMode.Navigation
                webController.showURLStringOnActionSheetTitle = false
                webController.showPageTitleOnTitleBar = true
                webController.showReloadButton = true
                webController.showActionButton = true
            }
        }
    }

    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let models = self.talentModels{
            return models.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("topCell", forIndexPath: indexPath) as! TopTableViewCell
        
        if let models = self.talentModels {
            let talent = models[indexPath.row]
            cell.nameLabel.text = talent.name
            let placeImage = UIImage(named: "loading")
            cell.iconImageView.setImageWithURL(NSURL(string:talent.imageUrl), placeholderImage: placeImage)
            cell.iconImageView.layer.cornerRadius = 75.0 * 0.5
            cell.iconImageView.clipsToBounds = true
            
            //http://widget.websta.me/in/i_am_kiko/?s=135&w=3.0&h=3&b=0&p=5.0
            
            let arrayStr = talent.officialUrl.componentsSeparatedByString("/")
            let account = arrayStr[arrayStr.count-1]
            let widgetBaseUrl = "http://widget.websta.me/in/\(account)/"
            
            let wCount : CGFloat = 3
            let hCount = 3
            let space : CGFloat = 5
            let offset : CGFloat = 2
            let iconWidth = (Util.displaySize().width-space*(wCount-1.0))/wCount
            let iconWidthInt = Int(ceilf(Float(iconWidth)))
            
            let resultUrl = "\(widgetBaseUrl)?s=\(iconWidthInt)&w=\(wCount)&h=\(hCount)&b=0&p=\(space)"
            Log.DLog("resultUrl:\(resultUrl)")
            
            //読み込む前にクリア
            let blankReq = NSURLRequest(URL: NSURL(string:"about:blank")!)
            cell.widgetWebView.loadRequest(blankReq)
            
            let req :NSURLRequest = NSURLRequest(URL: NSURL(string: resultUrl)!)
            cell.widgetWebView.loadRequest(req)
            
            cell.cellHeightConstraint.constant = Util.displaySize().width
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75+10+10+Util.displaySize().width
    }

}
