//
//  LikeRankingViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class LikeRankingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

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
                
//                let html : NSString? = NSString(data: responsobject as! NSData, encoding: NSJapaneseEUCStringEncoding)
                var html: NSString? = NSString(data:responsobject as! NSData, encoding:NSUTF8StringEncoding)
                println("html:\(html)")
                
                if html == nil {
                    println("html:nil")
                    return
                }
                
                var error : NSError? = nil
                var parser : HTMLParser? = HTMLParser(html: html as! String , error:&error)
                
                if error != nil {
                    println(error)
                }
                
                let bodyNode :HTMLNode? = parser?.body
                println("bodyNode:\(bodyNode)")
                
                
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Error!!")
            }
        )
        
    }
    

    // セルに表示するテキスト
    let texts = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    @IBAction func segmentChangeAction(sender: AnyObject) {
    }
    
}
