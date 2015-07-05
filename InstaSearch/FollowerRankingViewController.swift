
//  FollowerRankingViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class FollowerRankingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var followerRankings : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "フォロワーランキング"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        followerRankings.removeAllObjects()
        
        SVProgressHUD.show()
        self.requestToGetRanking()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let row = self.tableView.indexPathForSelectedRow(){
            self.tableView.deselectRowAtIndexPath(row, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
        if segue.identifier == "followerraking_to_detail"{
            let controller = segue.destinationViewController as! UserDetailViewController
            
            let cell = sender as! FollowerRankingTableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)
            let row = indexPath?.row
            
            let followerRanking = self.followerRankings[row!] as! FollowerRanking
            controller.followerRanking = followerRanking
        }
    }

    
    func requestToGetRanking(){
        
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        manager.responseSerializer = AFHTTPResponseSerializer()
        let url = "http://www.talentinsta.com/follower/99/"
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
                
                let followerRankings = ParseHelper.convertFollowerRankingFromHtml(html: html! as String)
                
                self.followerRankings.addObjectsFromArray(followerRankings as Array)
                
                self.tableView.reloadData()
                
            },
            failure: {( operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                SVProgressHUD.dismiss()
                Log.DLog("error \(error)")
                Log.DLog("error \(error.localizedDescription)")
        })
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followerRankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("followerRankingCell", forIndexPath: indexPath) as! FollowerRankingTableViewCell
        //UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "followerRankingCell") as! FollowerRankingTableViewCell
        
        let ranking = self.followerRankings[indexPath.row] as! FollowerRanking
        cell.nameLabel?.text = ranking.name
        cell.rankingLabel?.text = NSString(format: "%d", ranking.rankingNo) as String
        if ranking.imageUrl != nil {
            let url = ranking.imageUrl
            cell.iconImageView.setImageWithURL(NSURL(string:url!))
            //画像の大きさは150x150
        }
        cell.followerNumLabel?.text = ranking.followerString
        cell.categoryLabel?.text = ranking.junre
        return cell
    }
    
    func jumpToDetail(){
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        var detail  = storyboard1.instantiateViewControllerWithIdentifier("detail") as! UserDetailViewController
        self.navigationController?.pushViewController(detail, animated: true)
    }
    

}
