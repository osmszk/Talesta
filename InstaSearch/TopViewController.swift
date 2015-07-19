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
    case Singer
    case TalentWoman
    case ModelAndBikini
    case TalentMan
    case KoreanIdol
    case AkbGroup
    case Comedian
    case Creater
}

class TopViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guideView: UIView!
    @IBOutlet weak var guideCloseButton: UIButton!
    @IBOutlet weak var guideLabel: UILabel!
    
    @IBOutlet weak var guideViewHeightConstraint: NSLayoutConstraint!
    
    var talentModels : Results<SubTalentModel>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "トップ"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        
        self.talentModels = RealmHelper.subModelAll(CampaignType.TerraceHouse)
        
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
                        
                        self.talentModels = RealmHelper.subModelAll(CampaignType.TerraceHouse)
                        self.tableView.reloadData()
                    }
                }
            }
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
        UIView.animateWithDuration(0.8) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Private Methods
    
    func setupDatabase(){
        //        RealmHelper.deleteAll()
        
        RealmHelper.makeRealmModelIfNeeded()
        if RealmHelper.subModelAll(CampaignType.TerraceHouse).count==0{
            RealmHelper.makeSubRealmModel(CampaignType.TerraceHouse)
        }
        if RealmHelper.subModelAll(CampaignType.KoreanIdol).count==0{
            RealmHelper.makeSubRealmModel(CampaignType.KoreanIdol)
        }
    }
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "top_to_web"{
            let webController = segue.destinationViewController as! WebViewController
            
            let cell = sender as! TopTableViewCell
            let indexPath = self.tableView.indexPathForSelectedRow()
            let row = indexPath?.row
            
//            let thTalent = self.talentModels[row!] as TerracehouseTalentModel
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
