//
//  OtherViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class OtherViewController: UITableViewController ,UITableViewDelegate{
    
    let faqSection = 0
    let tutorialSection = 1
    let moreAppSection = 2
    let contactSection = 3
    let spcialThanksSection = 4;//2
    
    let settingSection = -1;//2
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
        textViewController.title = "素材"
        self.navigationController?.pushViewController(textViewController, animated: true)
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
    
    
    
}
