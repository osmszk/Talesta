//
//  LikeRankingViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class LikeRankingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var likeRankings : NSMutableArray = NSMutableArray()
    var likeNumbers : NSMutableArray = NSMutableArray()
    var adBannerView : UIView?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "週間LIKEランキング"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        let reloadButton = UIButton(type: UIButtonType.Custom)
        reloadButton.frame = CGRectMake(0, 0, 34, 34);
        reloadButton.setImage(UIImage(named: "barbtn_reload_white"), forState: UIControlState.Normal)
        reloadButton.addTarget(self, action: "pushedReloadButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reloadButton)
        
        self.showBannerAd()
        
        self.getLikeRanking("http://websta.me/hot/jp_posts")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Const.ENABLE_ANALYTICS{
            let build = GAIDictionaryBuilder.createScreenView().set(theClassName, forKey: kGAIScreenName).build() as NSDictionary
            GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pushedReloadButton(sender:UIButton){
        
        let segIndex = self.segmentedControl.selectedSegmentIndex
        switch segIndex{
        case 0:
            self.getLikeRanking("http://websta.me/hot/jp_posts")
        case 1:
            self.getLikeRanking("http://websta.me/hot/posts")
        default:
            Log.DLog("")
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
        
        ImobileSdkAds.showBySpotID(Const.AD_IMOBILE_SPOT_ID_BANNER_NAKA, view: self.adBannerView, sizeAdjust: true)
    }
    
    func getLikeRanking(url: NSString) {
        SVProgressHUD.show()
        
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(url as String,
            parameters: nil,
            timeoutInterval: 10,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                Log.DLog("Success!!")
                
                self.likeRankings.removeAllObjects()
                self.likeNumbers.removeAllObjects()
                
                let html: NSString? = NSString(data:responsobject as! NSData, encoding:NSUTF8StringEncoding)
//                Log.DLog("html:\(html)")
                
                if html == nil {
                    Log.DLog("html:nil")
                    SVProgressHUD.showErrorWithStatus("読込に失敗しました[html]")
                    return
                }
                
                var error : NSError? = nil
                let parser : HTMLParser = HTMLParser(html: html as! String , error:&error)
                
                if (error != nil) {
                    print(error)
                }
                
                let bodyNode : HTMLNode? = parser.body
                Log.DLog("bodyNode:\(bodyNode)")
                if bodyNode == nil {
                    Log.DLog("bodyNode")
                    SVProgressHUD.showErrorWithStatus("読込に失敗しました[body]")
                    return
                }
                
                let divs : [HTMLNode] = bodyNode!.findChildTagsAttr("div", attrName: "class", attrValue: "row hot-photo-row")
                Log.DLog("divs.count:\(divs.count)")
                for node : HTMLNode in divs {
                    let dict : NSMutableDictionary = NSMutableDictionary()
                    
                    // 画像のURL取得
                    let photoImageNodes:[HTMLNode] = node.findChildTagsAttr("div", attrName: "class", attrValue: "img-cover hot-photo-image img-thumbnail")
                    
                    for photoImageNode : HTMLNode in photoImageNodes {
                        let style : NSString = photoImageNode.getAttributeNamed("style")
                        Log.DLog("style:\(style)")
                        
                        // 正規表現でURLを抽出
                        let pattern : String = "https://.*jpg"
                        let regexp = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions())
                        let matches = regexp?.matchesInString(style as String, options:[], range:NSMakeRange(0, style.length))
                        Log.DLog("matches:\(matches)")
                        if matches != nil {
                            var results: [String] = []
                            for reg in matches! {
                                results.append( (style as NSString).substringWithRange(reg.range) )
                            }
                            dict["photoImage"] = results[0]
                            Log.DLog("photoImagePath:\(results)")
                        }
                    }
                    
                    let photoUserNode:[HTMLNode] = node.findChildTagsAttr("img", attrName: "class", attrValue: "hot-photo-user img-circle")
                    if photoUserNode.count != 0 {
                        let photoUserPath:NSString = photoUserNode[0].getAttributeNamed("src")
                        dict["userImage"] = photoUserPath
                        Log.DLog("photoUserPath:\(photoUserPath)")
                    }
                    
                    let divNodes:[HTMLNode] = node.findChildTagsAttr("div", attrName: "class", attrValue: "col-xs-5")
                    if divNodes.count != 0 {
                        // 詳細ページのリンク取得
                        let aNodes:[HTMLNode] = divNodes[0].findChildTags("a")
                        if aNodes.count != 0 {
                            let detailUrl = aNodes[0].getAttributeNamed("href")
                            dict["detailUrl"] = NSString(format: "http://websta.me/%@", detailUrl)
                            Log.DLog("detailUrl:\(detailUrl)")
                        }
                        
                        let pNodes:[HTMLNode]
                        if divNodes.count == 2 {
                            // ユーザーID取得
                            pNodes = divNodes[1].findChildTags("p")
                        } else {
                            let xs6Nodes:[HTMLNode] = node.findChildTagsAttr("div", attrName: "class", attrValue: "col-xs-6")
                            pNodes = xs6Nodes[0].findChildTags("p")
                        }
                        if pNodes.count != 0 {
                            let aNode:[HTMLNode] = pNodes[2].findChildTags("a")
                            let userId:NSString = aNode[0].contents
                            dict["userId"] = userId
                            Log.DLog("userId:\(userId)")
                        }
                    }
                    
                    self.likeRankings.addObject(dict)
                    
                    Log.DLog(node.className)
                }
                
                //1. <script>タグを抽出する
                //2. "number:"と","の間の文字列を正規表現で抽出
                //3. "number:"と","の文字列を、置換して削除
                let scriptNodes : Array<HTMLNode>? = bodyNode?.findChildTags("script")
                if let scriptNodesUnwrap = scriptNodes{
                    for scriptNode in scriptNodesUnwrap{
                        let script = scriptNode.contents
                        if !((script as NSString).containsString("number:")){
                            //number:が見つからなかったら次
                            continue
                        }
                        let nsSentence = script as NSString
                        //\[.+?\]
                        //number:(.*),$
                        
                        Log.DLog("script:\(nsSentence)")
                        
                        //[^）]*（(.*?)）[^（]*
                        //[^,]*number:(.*?),[^number:]*
                        //number:(.*),
                        //[^,]*number:(.*?),[^number:]*
                        
                        let regex = try? NSRegularExpression(pattern: "number:(.*),", options: NSRegularExpressionOptions())
                        //ref:
                        if let result = regex?.matchesInString(nsSentence as String, options: NSMatchingOptions(), range: NSMakeRange(0, nsSentence.length)){
                            for reg in result{
//                                Log.DLog("reg:\(reg)")
                                let expression = nsSentence.substringWithRange(reg.range)
//                                Log.DLog("expression:\(expression)")
                                let str1 = expression.stringByReplacingOccurrencesOfString("number: ", withString: "", options: [], range: nil)
                                let number = str1.stringByReplacingOccurrencesOfString(",", withString: "", options: [], range: nil)
                                Log.DLog("number:\(number)")
                                
                                self.likeNumbers.addObject(number as String)
                            }
                        }
                        //"number:(.*),$"
                    }
                }
                Log.DLog("numbers:\(self.likeNumbers)")
                
                SVProgressHUD.dismiss()
                
                self.tableView.reloadData()
                
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                SVProgressHUD.showErrorWithStatus("情報取得に失敗しました")
                Log.DLog("Error!!")
            }
        )
    }
    
    func getDetail(url: NSString) {
        SVProgressHUD.show()
        
        Log.DLog("url:\(url)")
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(url as String,
            parameters: nil,
            timeoutInterval: 10,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                Log.DLog("Success!!")
                
                let html: NSString? = NSString(data:responsobject as! NSData, encoding:NSUTF8StringEncoding)
                Log.DLog("html:\(html)")
                
                if html == nil {
                    Log.DLog("html:nil")
                    SVProgressHUD.showErrorWithStatus("読込に失敗しました[html]")
                    return
                }
                
                var error : NSError? = nil
                let parser : HTMLParser = HTMLParser(html: html as! String , error:&error)
                
                if (error != nil) {
                    print(error)
                }
                
                let bodyNode : HTMLNode? = parser.body
                Log.DLog("bodyNode:\(bodyNode)")
                if bodyNode == nil {
                    Log.DLog("bodyNode")
                    SVProgressHUD.showErrorWithStatus("読込に失敗しました[body]")
                    return
                }
                
                let ulNodes : [HTMLNode] = bodyNode!.findChildTagsAttr("ul", attrName: "class", attrValue: "dropdown-menu")
                Log.DLog("uls:\(ulNodes.count)")
                var detailUrl = ""
                if ulNodes.count != 0 {
                    let liNodes:[HTMLNode] = ulNodes[1].findChildTags("li")
                    if liNodes.count > 3 {
                        //image
                        let aNodes = liNodes[4].findChildTags("a")//
                        if aNodes.count != 0 {
                            detailUrl = aNodes[0].getAttributeNamed("href")
                            Log.DLog("detailUrl(image):\(detailUrl)")
                        }
                    }else if liNodes.count == 3{
                        //movie
                        let aNodes = liNodes[2].findChildTags("a")//
                        if aNodes.count != 0 {
                            detailUrl = aNodes[0].getAttributeNamed("href")
                            Log.DLog("detailUrl(movie):\(detailUrl)")
                        }
                        
                    }
                }
                
                SVProgressHUD.dismiss()
                
                if detailUrl == ""{
                    SVProgressHUD.showErrorWithStatus("情報取得に失敗しました[detail]")
                    return
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let webController = storyboard.instantiateViewControllerWithIdentifier("web") as! WebViewController
                webController.urlStr = detailUrl
                
                webController.mode = JOWebBrowserMode.Navigation
                webController.showURLStringOnActionSheetTitle = false
                webController.showPageTitleOnTitleBar = true
                webController.showReloadButton = true
                webController.showActionButton = true
                self.navigationController?.pushViewController(webController, animated: true)
                
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                Log.DLog("Error!!")
                SVProgressHUD.showErrorWithStatus("情報取得に失敗しました")
            }
        )
    }
    
    // Cell が選択された場合
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let dict : NSDictionary = likeRankings[indexPath.row] as! NSDictionary
        self.getDetail((dict["detailUrl"] as? String)!)
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeRankings.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LikeRankingTableViewCell", forIndexPath: indexPath) as! LikeRankingTableViewCell
//        let cell: LikeRankingTableViewCell = LikeRankingTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "LikeRankingTableViewCell")
        
        let dict : NSDictionary = likeRankings[indexPath.row] as! NSDictionary
        Log.DLog("dict:\(dict)")
        
        cell.rankLabel.text = NSString(format: "%d", indexPath.row + 1) as String
        
        cell.photoImageView.image = nil
        if let photoImagePath: AnyObject = dict["photoImage"] {
            cell.photoImageView.setImageWithURL(NSURL(string:photoImagePath as! String))
        }
        
        cell.userImageView.image = nil
        if let userImagePath: AnyObject = dict["userImage"] {
            cell.userImageView.setImageWithURL(NSURL(string:userImagePath as! String))
            cell.userImageView.layer.cornerRadius = 40.0 * 0.5
            cell.userImageView.clipsToBounds = true
        }
        
        if let userId: AnyObject = dict["userId"] {
            cell.userLabel?.text = userId as? String
        }
        
        if self.likeNumbers.count > indexPath.row {
            let likeNumStr = self.likeNumbers[indexPath.row] as? String
            cell.likeLabel?.text = commaNumber(likeNumStr)
        }else{
            cell.likeLabel?.text = "No Data"
        }
        
        cell.imageHeightConstraint.constant = Util.displaySize().width-20
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let imageWidth = Util.displaySize().width-20
        return imageWidth+54+10
    }
    
    func commaNumber(str:String?) -> String{
        if let intNum = Int(str!){
            let num = NSNumber(integer: intNum)
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            return formatter.stringFromNumber(num)!
        }
        return ""
    }
    
    @IBAction func didValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.getLikeRanking(Const.URL_LIKE_RANKING_JP)
            
        case 1:
            self.getLikeRanking(Const.URL_LIKE_RANKING_US)
            
        default:
            Log.DLog("default")
        }
    }
}
