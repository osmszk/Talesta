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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "LIKEランキング"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.getLikeRanking("http://websta.me/hot/jp_posts")
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
    
    
    func getLikeRanking(url: NSString) {
        SVProgressHUD.show()
        
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(url as String,
            parameters: nil,
            timeoutInterval: 10,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                println("Success!!")
                
                self.likeRankings.removeAllObjects()
                
                let html: NSString? = NSString(data:responsobject as! NSData, encoding:NSUTF8StringEncoding)
//                println("html:\(html)")
                
                if html == nil {
                    println("html:nil")
                    return
                }
                
                var error : NSError? = nil
                var parser : HTMLParser = HTMLParser(html: html as! String , error:&error)
                
                if (error != nil) {
                    println(error)
                }
                
                var bodyNode : HTMLNode? = parser.body
                println("bodyNode:\(bodyNode)")
                if bodyNode == nil {
                    println("bodyNode")
                    return
                }
                
                let divs : [HTMLNode] = bodyNode!.findChildTagsAttr("div", attrName: "class", attrValue: "row hot-photo-row")
                println("divs.count:\(divs.count)")
                for node : HTMLNode in divs {
                    var dict : NSMutableDictionary = NSMutableDictionary()
                    
                    let photoImageNodes:[HTMLNode] = node.findChildTagsAttr("img", attrName: "class", attrValue: "hot-photo-image img-thumbnail")
                    if photoImageNodes.count != 0 {
                        let photoImagePath:NSString = photoImageNodes[0].getAttributeNamed("src")
                        dict["photoImage"] = photoImagePath
                        println("photoImagePath:\(photoImagePath)")
                    } else {
                        let smallPhotoImageNodes:[HTMLNode] = node.findChildTagsAttr("img", attrName: "class", attrValue: "hot-photo-image-small img-thumbnail")
                        if smallPhotoImageNodes.count != 0 {
                            let photoImagePath:NSString = smallPhotoImageNodes[0].getAttributeNamed("src")
                            dict["photoImage"] = photoImagePath
                            println("photoImagePath:\(photoImagePath)")
                        }
                    }
                    
                    let photoUserNode:[HTMLNode] = node.findChildTagsAttr("img", attrName: "class", attrValue: "hot-photo-user img-circle")
                    if photoUserNode.count != 0 {
                        let photoUserPath:NSString = photoUserNode[0].getAttributeNamed("src")
                        dict["userImage"] = photoUserPath
                        println("photoUserPath:\(photoUserPath)")
                    }
                    
                    let divNodes:[HTMLNode] = node.findChildTagsAttr("div", attrName: "class", attrValue: "col-xs-5")
                    if divNodes.count != 0 {
                        // 詳細ページのリンク取得
                        let aNodes:[HTMLNode] = divNodes[0].findChildTags("a")
                        if aNodes.count != 0 {
                            let detailUrl = aNodes[0].getAttributeNamed("href")
                            dict["detailUrl"] = NSString(format: "http://websta.me/%@", detailUrl)
                            println("detailUrl:\(detailUrl)")
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
                            println("userId:\(userId)")
                        }
                    }
                    
                    self.likeRankings.addObject(dict)
                    
                    println(node.className)
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
                        
                        var regex = NSRegularExpression(pattern: "number:(.*),", options: NSRegularExpressionOptions.allZeros, error: nil)
                        //ref:
                        if let result = regex?.matchesInString(nsSentence as String, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, nsSentence.length)){
                            for reg in result{
//                                println("reg:\(reg)")
                                let expression = nsSentence.substringWithRange(reg.range)
//                                Log.DLog("expression:\(expression)")
                                let str1 = expression.stringByReplacingOccurrencesOfString("number: ", withString: "", options: nil, range: nil)
                                let number = str1.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
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
                SVProgressHUD.dismiss()
                println("Error!!")
            }
        )
        
    }
    
    func getDetail(url: NSString) {
        SVProgressHUD.show()
        
        println("url:\(url)")
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(url as String,
            parameters: nil,
            timeoutInterval: 10,
            success: {(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) in
                println("Success!!")
                
                let html: NSString? = NSString(data:responsobject as! NSData, encoding:NSUTF8StringEncoding)
                println("html:\(html)")
                
                if html == nil {
                    println("html:nil")
                    return
                }
                
                var error : NSError? = nil
                var parser : HTMLParser = HTMLParser(html: html as! String , error:&error)
                
                if (error != nil) {
                    println(error)
                }
                
                var bodyNode : HTMLNode? = parser.body
                println("bodyNode:\(bodyNode)")
                if bodyNode == nil {
                    println("bodyNode")
                    return
                }
                
                let ulNodes : [HTMLNode] = bodyNode!.findChildTagsAttr("ul", attrName: "class", attrValue: "dropdown-menu")
                println("uls:\(ulNodes.count)")
                var detailUrl = ""
                if ulNodes.count != 0 {
                    let liNodes:[HTMLNode] = ulNodes[1].findChildTags("li")
                    if liNodes.count != 0 {
                        let aNodes = liNodes[4].findChildTags("a")
                        if aNodes.count != 0 {
                            detailUrl = aNodes[0].getAttributeNamed("href")
                            println("detailUrl:\(detailUrl)")
                        }
                    }
                }
                
                SVProgressHUD.dismiss()
                
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
                println("Error!!")
                SVProgressHUD.dismiss()
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
        
        cell.rankLabel.text = NSString(format: "%d位", indexPath.row + 1) as String
        
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
        
        cell.likeLabel?.text = self.likeNumbers[indexPath.row] as? String
        
        return cell
    }
    
    @IBAction func didValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.getLikeRanking("http://websta.me/hot/jp_posts")
            
        case 1:
            self.getLikeRanking("http://websta.me/hot/posts")
            
        default:
            Log.DLog("default")
        }
    }
}
