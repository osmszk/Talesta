//
//  FollowerRankingViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class FollowerRankingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "follower"
        
        
        SVProgressHUD.show()
        self.requestToGetRanking()
        
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
    
    func requestToGetRanking(){
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
//        let serializer: AFJSONRequestSerializer =   AFJSONRequestSerializer()
//        manager.requestSerializer = serializer
        manager.responseSerializer = AFHTTPResponseSerializer()
//        manager.responseSerializer.acceptableContentTypes = S
        //[String: AnyObject]
//        let url = "http://www.talentinsta.com/follower/99/"
        let url = "http://sports.yahoo.co.jp/nba/news/list/"
        manager.GET(url,
            parameters: nil,
            success:{(operation: AFHTTPRequestOperation!, responsobject: AnyObject!) -> Void in
                
                SVProgressHUD.dismiss()
                
                //ref:http://blog.f60k.com/objective-c%E3%81%A8swift%E3%81%AE%E7%B5%84%E3%81%BF%E5%90%88%E3%82%8F%E3%81%9B%E6%96%B9%E3%81%AE%E3%81%BE%E3%81%A8%E3%82%81/
                println("success")
                
                let html = NSString(data: responsobject as! NSData, encoding: NSUTF8StringEncoding)
                println("html:\(html)")
                
                
                
            }) { ( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.dismiss()
                println("error \(error)")
                println("error \(error.localizedDescription)")
        }
        
    }

}
