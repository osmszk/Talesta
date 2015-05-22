//
//  TopViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

//    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initLabel()
        
//        label?.text = "teststs"
        
//        NSLog("%@",label);
        self.title = "top"
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer: AFJSONRequestSerializer =   AFJSONRequestSerializer()
        manager.requestSerializer = serializer
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet,id&q=clash+of+clans+commercial%7Ccomedy&maxResults=20&key=AIzaSyAEUijSNYxVgVwI6Xpkp9cw1l1wFL8azCA"
        
        manager.GET(url, parameters: nil,
            success:{(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) -> Void in
            println("success")
            println(responsobject)
                
            }) { ( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("error")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//    }
//    
//    required init(coder aDecoder: NSCoder){
//        super.init(coder: aDecoder)
//    }
    
//    func initLabel(){
//        
//        let helloLabel: UILabel = UILabel(frame: CGRectMake(60, 100, 200, 30))
//        
//        helloLabel.text = "Hello World!"
//        helloLabel.textAlignment = NSTextAlignment.Center
//        helloLabel.textColor = UIColor.whiteColor()
//        helloLabel.backgroundColor = UIColor.orangeColor()
//        
//        self.view.addSubview(helloLabel)
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
