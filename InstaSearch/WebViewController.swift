//
//  WebViewController.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/07.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var webView : UIWebView!
    
    var urlStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = urlStr{
            let req : NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            self.webView.loadRequest(req)   
        }
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

}
