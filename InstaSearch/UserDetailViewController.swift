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
    @IBOutlet weak var officialButton: HTPressableButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var widgetWebView: UIWebView!
    @IBOutlet weak var widgetWebViewHConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHConstraint: NSLayoutConstraint!
    
    var talentUser : TalentUser? = TalentUser()
    var followerRanking : FollowerRanking?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        
        self.scrollContentView.backgroundColor = UIColor.whiteColor()
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        self.widgetWebViewHConstraint.constant = Util.displaySize().width
        //TODO:contentViewHConstraintを動的に
        
        self.officialButton.style = HTPressableButtonStyle.Rect
        self.officialButton.buttonColor = UIColor.ht_pinkRoseColor()
        self.officialButton.shadowColor = UIColor.ht_pinkRoseDarkColor()
        self.officialButton.setTitle("フォローする", forState: UIControlState.Normal)
        self.officialButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.widgetWebView.scrollView.scrollEnabled = false
        self.widgetWebView.scrollView.bounces = false
        self.widgetWebView.userInteractionEnabled = false
        
        self.title = self.followerRanking?.name
        
        self.officialButton.enabled = false
        self.nameLabel.text = self.followerRanking?.name
        if let followerStr = self.followerRanking?.followerString{
            self.followersLabel.text = followerStr
        }else{
            self.followersLabel.text = ""
        }
        
        if let iconUrl = self.followerRanking?.imageUrl{
            self.iconImageView.setImageWithURL(NSURL(string:iconUrl))
            self.talentUser?.iconImageUrl = iconUrl
        }
        
        SVProgressHUD.show()
        self.requestToGetUserDetail()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Methods

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail_to_webview"{
            let controller = segue.destinationViewController as! WebViewController
            controller.urlStr = self.talentUser?.officialUrl
        }
    }
    
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
                
                SVProgressHUD.dismiss()
                Log.DLog("success")
                
                let html : NSString? = NSString(data: responsobject as! NSData, encoding: NSJapaneseEUCStringEncoding)
                if html == nil {
                    Log.DLog("failed!)")
                    SVProgressHUD.showErrorWithStatus("読み込みに失敗しました")
                    return
                }
                
                Log.DLog("html:\(html)")
                
                self.talentUser =  ParseHelper.convertTalentUserFromHtml(html: html as! String , talent: self.talentUser!)
                
//                if let iconUrl = self.talentUser?.iconImageUrl{
//                    self.iconImageView.setImageWithURL(NSURL(string:iconUrl))
//                }
                
                self.nameLabel.text = self.talentUser?.talentInstaName
                
                if self.talentUser?.officialUrl != nil {
                    self.officialButton.enabled = true
                }
                
                if let widgetUrl = self.talentUser?.widgetUrl {
                    //ex)http://widget.stagram.com/in/i_am_kiko/?s=180&w=3&h=2&b=0&p=5
                    
                    let arrayStr = widgetUrl.componentsSeparatedByString("?")
                    let widgetBaseUrl = arrayStr[0]
                    
                    let wCount : CGFloat = 3
                    let hCount = 3
                    let space : CGFloat = 5
                    let offset : CGFloat = 2
                    let iconWidth = (Util.displaySize().width-space*(wCount-1.0))/wCount
                    let iconWidthInt = Int(ceilf(Float(iconWidth)))
                    
                    let resultUrl = "\(widgetBaseUrl)?s=\(iconWidthInt)&w=\(wCount)&h=\(hCount)&b=0&p=\(space)"
                    Log.DLog("resultUrl:\(resultUrl)")
                    
                    let req :NSURLRequest = NSURLRequest(URL: NSURL(string: resultUrl)!)
                    self.widgetWebView.loadRequest(req)
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
    
    // MARK: - Delegate

}
