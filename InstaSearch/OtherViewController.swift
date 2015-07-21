//
//  OtherViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import MessageUI
import Social

class OtherViewController: UITableViewController ,UITableViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate{
    
    let faqSection = 0
    let moreAppSection = 1
    let friendSection = 2
    let contactSection = 3
    let spcialThanksSection = 4;

    let tutorialSection = -1
    let settingSection = -1;
    let sectionCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "その他"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Const.ENABLE_ANALYTICS{
            let screenName = reflect(self).summary
            let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary
            GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
        }
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
    
    // MARK: - Action
    
    func pushedReviewButton(sender:AnyObject){
        let url = NSURL(string: Const.URL_APP_STORE)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func moveToFaqView(){
        let path = "\(NSBundle.mainBundle().resourcePath)/faq.txt"
        let data = NSData(contentsOfFile: path)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let textViewController = UIViewController()
        let textView = UITextView(frame: CGRectMake(0, 0, Util.displaySize().width, Util.displaySize().height))
        textView.editable = false;
        textView.selectable = false;
        textView.text = String(string!)
        textViewController.view = textView;
        textViewController.title = "FAQ"
        self.navigationController?.pushViewController(textViewController, animated: true)
    }
    
    func moveToSozaiView(){
        let path = "\(NSBundle.mainBundle().resourcePath)/sozai.txt"
        let data = NSData(contentsOfFile: path)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let textViewController = UIViewController()
        let textView = UITextView(frame: CGRectMake(0, 0, Util.displaySize().width, Util.displaySize().height))
        textView.editable = false;
        textView.selectable = false;
        textView.text = String(string!)
        textViewController.view = textView;
        textViewController.title = "Special Thanks"
        self.navigationController?.pushViewController(textViewController, animated: true)
    }
    
    func moveToLisenceView(){
        let path = "\(NSBundle.mainBundle().resourcePath)/license.txt"
        let data = NSData(contentsOfFile: path)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let textViewController = UIViewController()
        let textView = UITextView(frame: CGRectMake(0, 0, Util.displaySize().width, Util.displaySize().height))
        textView.editable = false;
        textView.selectable = false;
        textView.text = String(string!)
        textViewController.view = textView;
        textViewController.title = "ライセンス"
        self.navigationController?.pushViewController(textViewController, animated: true)
        
    }
    
    func devicePlatform() -> String {
         var size : Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](count: size, repeatedValue: 0)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        //Stringに変換
        return String.fromCString(machine)!
    }
    
    func openMailApp(){
        if MFMailComposeViewController.canSendMail() {
            let mailPicker = MFMailComposeViewController()
            mailPicker.mailComposeDelegate = self
            mailPicker.setToRecipients([Const.SUPPORT_MAIL])
            
            
            
            let device = UIDevice.currentDevice()
            var msg = ""
            msg+"\n\n\n---------\n"
            msg+"※今後の改修のため、お客様情報を送信します\n"
            msg+"Version:\(Util.appVersionString())\n"
            msg+"iOS:\(device.systemVersion)\n"
            msg+"Device:\(self.devicePlatform())\n"
            msg+"Screen:\(NSStringFromCGSize(Util.displaySize()))\n"
            mailPicker.setSubject("\(Const.APP_NAME) お問い合わせ/ご要望")
            mailPicker.setMessageBody(msg, isHTML: false)
            self.presentViewController(mailPicker, animated: true, completion: nil)
        }else {
            
            let alertMail = UIAlertView(title: "Information", message: "No mail Function", delegate: nil, cancelButtonTitle: "OK")
            alertMail.show()
        }
    }
    
    func openUrl(url:String){
        let url = NSURL(string: url)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func shareToFriend(){
        let actionSheet = UIActionSheet(title: "友達にシェア", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"LINE","Twitter","Facebook")
        actionSheet.tag = 1
        actionSheet.actionSheetStyle = UIActionSheetStyle.Default
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    func sendViaLine(text:String){
        let msgText = Util.changeUrlEncode(text)
        let urlString = "line://msg/text/\(msgText)"
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: urlString)!){
            UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
            if Const.ENABLE_ANALYTICS{
                let build = GAIDictionaryBuilder.createEventWithCategory("conversion", action: "share", label: "line", value: nil).build()
                GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
            }
        } else {
            Util.showAlert("Error", message: "You cannot use LINE :(")
        }
    }
    
    func sendViaTwitter(text:String){
        if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            Util.showAlert("Error", message: "You cannot use Twitter :(")
        }
        
        let tweetViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let msgText = "\(text) \(Const.HASH_TAG)"
        tweetViewController.setInitialText(msgText)
        tweetViewController.addURL(NSURL(string: Const.URL_APP_STORE)!)
        
        //typealias SLComposeViewControllerCompletionHandler = (SLComposeViewControllerResult) -> Void
        let handler :SLComposeViewControllerCompletionHandler = {(result:SLComposeViewControllerResult) -> Void in
            Log.DLog("")
            if (result == SLComposeViewControllerResult.Cancelled) {
                Log.DLog("Cancelled");
            } else{
                Log.DLog("Done");
                if Const.ENABLE_ANALYTICS{
                    let build = GAIDictionaryBuilder.createEventWithCategory("conversion", action: "share", label: "twitter", value: nil).build()
                    GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
                }
                
                Util.showAlert("", message: "シェア成功！")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        tweetViewController.completionHandler = handler
        self.presentViewController(tweetViewController, animated: true, completion: nil)
    }
    
    func sendViaFacebook(text:String){
        if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            Util.showAlert("Error", message: "You cannot use Facebook :(")
        }
        
        let tweetViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let msgText = "\(text) \(Const.HASH_TAG)"
        tweetViewController.setInitialText(msgText)
        tweetViewController.addURL(NSURL(string: Const.URL_APP_STORE)!)
        
        //typealias SLComposeViewControllerCompletionHandler = (SLComposeViewControllerResult) -> Void
        let handler :SLComposeViewControllerCompletionHandler = {(result:SLComposeViewControllerResult) -> Void in
            Log.DLog("")
            if (result == SLComposeViewControllerResult.Cancelled) {
                Log.DLog("Cancelled");
            } else{
                Log.DLog("Done");
                if Const.ENABLE_ANALYTICS{
                    let build = GAIDictionaryBuilder.createEventWithCategory("conversion", action: "share", label: "facebook", value: nil).build()
                    GAI.sharedInstance().defaultTracker.send(build as [NSObject : AnyObject])
                }
                
                Util.showAlert("", message: "シェア成功！")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        tweetViewController.completionHandler = handler
        self.presentViewController(tweetViewController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.spcialThanksSection {
            if indexPath.row == 0{
                self.moveToSozaiView()
                return;
            }else{
                self.moveToLisenceView()
                return;
            }
        }else if indexPath.section == self.contactSection {
            if indexPath.row == 0 {
                self.openMailApp()
            }else{
                self.openUrl(Const.URL_SUPPORT_TWITTER)
            }
            if let index = self.tableView.indexPathForSelectedRow(){
                self.tableView.deselectRowAtIndexPath(index, animated: true)
            }
        }else if(indexPath.section == self.tutorialSection){
        }else if(indexPath.section == self.faqSection){
            self.moveToFaqView()
        }else if(indexPath.section == self.moreAppSection){
            if (indexPath.row == 0) {
                self.openUrl(Const.URL_APP_STORE_PICTUNES)
            }else if(indexPath.row == 1){
                self.openUrl(Const.URL_APP_STORE_UNLOCKER)
            }else if(indexPath.row == 2){
                self.openUrl(Const.URL_APP_STORE_MEMO)
            }else if(indexPath.row == 3){
                self.openUrl(Const.URL_APP_STORE_CALENDER)
            }else{
                self.openUrl(Const.URL_APP_STORE_ALL)
            }
        }else if (indexPath.section == self.settingSection){
            
        }else if (indexPath.section == self.friendSection){
            //友達にすすめる
            self.shareToFriend()
        }
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch (result.value){
        case MFMailComposeResultCancelled.value:
            Log.DLog("cancel")
        case MFMailComposeResultSaved.value:
            Log.DLog("Saved")
        case MFMailComposeResultSent.value:
            Log.DLog("Saved")
        case MFMailComposeResultFailed.value:
            let alertFailed = UIAlertView(title: "Failed", message: "", delegate: nil, cancelButtonTitle: "OK")
            alertFailed.show()
        default:
            Log.DLog("")
        }
    }
    
    //MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if (actionSheet.tag == 1) {
            let disp = "芸能人のインスタグラムを探せるアプリ"
            let appName = Const.APP_NAME
            let text = "\(disp)『\(appName)』 \(Const.URL_APP_STORE)"
            if (buttonIndex == 0) {
                //LINE
                self.sendViaLine(text)
            }else if (buttonIndex == 1) {
                //Twitter
                self.sendViaTwitter(text)
            }else if (buttonIndex == 2) {
                //Facebook
                self.sendViaFacebook(text)
            } else  {
                //cancel
            }
            if let index = self.tableView.indexPathForSelectedRow(){
                self.tableView.deselectRowAtIndexPath(index, animated: true)
            }
        }
    }
    
}
