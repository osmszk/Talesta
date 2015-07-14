//
//  TopViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class TopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guideView: UIView!
    
    var talentModels = RealmHelper.terraceHousetalentModelAll()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initLabel()
        
//        label?.text = "teststs"
        
//        NSLog("%@",label);
        self.navigationItem.title = "インスタ芸能人！"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        
        //韓流かテラスハウス特集
        //韓流
        //http://www.talentinsta.com/tllink/tllink.php?mode=ct&ct=18&p=1
        //テラスハウス
        //http://www.talentinsta.com/matome/index.php?p=%a5%c6%a5%e9%a5%b9%a5%cf%a5%a6%a5%b9

        
        
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.talentModels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("topCell", forIndexPath: indexPath) as! TopTableViewCell
        
        let talent = self.talentModels[indexPath.row]
        cell.nameLabel.text = talent.name
        let placeImage = UIImage(named: "loading")
        cell.iconImageView.setImageWithURL(NSURL(string:talent.imageUrl), placeholderImage: placeImage)
        
        
        //http://widget.websta.me/in/i_am_kiko/?s=135&w=3.0&h=3&b=0&p=5.0
        
        let arrayStr = talent.officialUrl.componentsSeparatedByString("/")
        let account = arrayStr[arrayStr.count-1]
        let widgetBaseUrl = "http://widget.websta.me/in/\(account)/"//http://widget.websta.me/in/i_am_kiko/
        
        let wCount : CGFloat = 3
        let hCount = 3
        let space : CGFloat = 5
        let offset : CGFloat = 2
        let iconWidth = (Util.displaySize().width-space*(wCount-1.0))/wCount
        let iconWidthInt = Int(ceilf(Float(iconWidth)))
        
        let resultUrl = "\(widgetBaseUrl)?s=\(iconWidthInt)&w=\(wCount)&h=\(hCount)&b=0&p=\(space)"
        Log.DLog("resultUrl:\(resultUrl)")
        
        let req :NSURLRequest = NSURLRequest(URL: NSURL(string: resultUrl)!)
        cell.widgetWebView.loadRequest(req)
        
        return cell
    }

}
