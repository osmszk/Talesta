//
//  DetailViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var officialButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var userProfile : User? = User()
//    var profileUrl : String?
    var followerRanking : FollowerRanking?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        
        self.scrollContentView.backgroundColor = UIColor.whiteColor()
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Detail"
        
        
        self.officialButton.enabled = false
        
        SVProgressHUD.show()
        self.requestToGetUserDetail()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Custom
    
    func requestToGetUserDetail(){
        
        if self.followerRanking == nil{
            SVProgressHUD.dismiss()
            return
        }
        
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = self.followerRanking!.profileUrl
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
                
                Log.DLog("html:\(html)")
                
                
                var error : NSError? = nil
                var parser : HTMLParser? = HTMLParser(html: html! as String, encoding: NSUTF8StringEncoding, error: &error)//parse error
                let bodyNode :HTMLNode? = parser?.body
                
                
                let tdNodes : Array<HTMLNode>? = bodyNode?.findChildTags("td")
                var k = 0
                var trStartIndex  =  0
                
                var iconImageUrl : String? = nil
                var officialUrl : String? = nil
                var displayName : String? = nil
                if let tdNodesUnwrap = tdNodes{
                    for tdNode in tdNodesUnwrap{
                        let imgNode = tdNode.findChildTag("img")
                        let name2Node = tdNode.findChildTag("h2")
                        let name1Node = tdNode.findChildTag("h1")
                        if imgNode == nil && name2Node == nil && name1Node == nil{
                            continue
                        }
                        
                        if let imgUrl = imgNode?.getAttributeNamed("src"){
                            if (imgUrl as NSString).containsString("instagram") {
                                iconImageUrl = imgUrl
                            }
                        }
                        
                        if let officalUrlNode = name2Node?.findChildTag("a"){
                            if let offclUrl = officalUrlNode.getAttributeNamed("href") as String?{
                                officialUrl = offclUrl as String?
                            }
                        }
                        
                        if let name = name1Node?.contents{
                            displayName = name
                        }
                    }
                }
                
                Log.DLog("iconImageUrl \(iconImageUrl)")
                Log.DLog("officialUrl \(officialUrl)")
                Log.DLog("displayName \(displayName)")
                
                
                if let iconUrl = iconImageUrl{
                    self.iconImageView.setImageWithURL(NSURL(string:iconUrl))
                }
                
                self.nameLabel.text = displayName
                
                if officialUrl != nil {
                    self.officialButton.enabled = true
                }
                
            },
            failure: {( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.dismiss()
                Log.DLog("error \(error)")
                Log.DLog("error \(error.localizedDescription)")
        })
        
    }
        
    
    
    // MARK: - Action
    
    @IBAction func pushedOfficialButton(sender: AnyObject) {
        Log.DLog("pushedOfficialButton")
        
    }
    
    @IBAction func pushedFollowButton(sender: AnyObject) {
        Log.DLog("pushedFollowButton")
    }
    
    // MARK: - Delegate

}
