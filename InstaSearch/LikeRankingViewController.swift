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

        // Do any additional setup after loading the view.
        self.title = "Like"
        
        self.getLikeRanking()
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
    
    
    func getLikeRanking() {
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = "http://websta.me/hot/jp_posts"
        manager.GET(url,
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
                        let pNodes:[HTMLNode] = divNodes[1].findChildTags("p")
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
                
                self.tableView.reloadData()
                
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Error!!")
            }
        )
        
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
        }
        
        if let userId: AnyObject = dict["userId"] {
            cell.userLabel?.text = userId as? String
        }
        
        cell.likeLabel?.text = self.likeNumbers[indexPath.row] as? String
        
        return cell
    }
    
    @IBAction func segmentChangeAction(sender: AnyObject) {
    }
    
}
