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
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = "http://www.talentinsta.com/follower/99/"
        manager.GET(url,
            parameters: nil,
            timeoutInterval: 10,
            success: { (operation : AFHTTPRequestOperation!, responsobject: AnyObject!) -> Void in
                
                SVProgressHUD.dismiss()
                
                //ref:http://blog.f60k.com/objective-c%E3%81%A8swift%E3%81%AE%E7%B5%84%E3%81%BF%E5%90%88%E3%82%8F%E3%81%9B%E6%96%B9%E3%81%AE%E3%81%BE%E3%81%A8%E3%82%81/
                println("success")
                
                let html : NSString? = NSString(data: responsobject as! NSData, encoding: NSJapaneseEUCStringEncoding)
//                println("responsobject:\(responsobject)")
//                println("operation:\(operation)")
                println("html:\(html)")
                
                var followerRankings = NSMutableArray()
                var error : NSError? = nil
                var parser : HTMLParser? = HTMLParser(html: html as! String , error:&error)//parse error
                let bodyNode :HTMLNode? = parser?.body
                
                let trNodes : Array<HTMLNode>? = bodyNode?.findChildTags("tr")
                var k = 0
                var trStartIndex  =  0
                
                //オプショナルのオブジェクト郡をfor-inでつかうときはアンラップしてからつかう
                //ref:http://stackoverflow.com/questions/26852656/loop-through-anyobject-results-in-does-not-have-a-member-named-generator
                if let trNodesUnwrap = trNodes{
                    for trNode in trNodesUnwrap{
                        let tdNodes : Array<HTMLNode>? = trNode.findChildTags("td")
                        if let tdNodesUnwap = tdNodes{
                            for tdNode in tdNodesUnwap{
                                let contents : String = tdNode.contents
                                if(contents == "フォロワー数"){
                                    trStartIndex = k+1
                                }
                            }
                        }
                        k++
                    }
                }
                
                //アンラップについて
                //ref:http://qiita.com/cotrpepe/items/518c4476ca957a42f5f1
                
                for var i:Int=0; i<50; ++i{
                    if let trNodesUnwap = trNodes{
                        let node0 : HTMLNode? = trNodesUnwap[trStartIndex+i]
                        let tdNodes : Array<HTMLNode>? = node0?.findChildTags("td")
                        
                        if let tdNodesUnwap = tdNodes {
                            let rankingNumNode : HTMLNode? = tdNodesUnwap[0]
                            let nameNode : HTMLNode? = tdNodesUnwap[1].findChildTag("a")?.findChildTag("b")
                            let junreNode : HTMLNode? = tdNodesUnwap[2]
                            let followerNumNode : HTMLNode? = tdNodesUnwap[tdNodes!.count-1]
                            
                            println("\(rankingNumNode!.contents) \(nameNode!.contents) \(junreNode!.contents) \(followerNumNode!.contents)")
                            
                            let ranking : Int! = rankingNumNode!.contents.toInt()
                            let followerRanking = FollwerRanking(rankingNo: ranking, name: nameNode!.contents, junre: junreNode!.contents, follower: followerNumNode!.contents)
                            
                            followerRankings.addObject(followerRanking)
                        }
                    }
                }
                
        
            },
            failure: {( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.dismiss()
                println("error \(error)")
                println("error \(error.localizedDescription)")
        })
        
    }

}
