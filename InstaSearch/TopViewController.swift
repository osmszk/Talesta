//
//  TopViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class TopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

//    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guideView: UIView!
    
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("top_cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "aaaa"
        
        return cell
    }

}
