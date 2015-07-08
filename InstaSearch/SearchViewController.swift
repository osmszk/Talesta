//
//  SearchViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    let talentObject = RealmHelper.talentModelAll()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "検索"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
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
    
        if segue.identifier == "search_to_deail"{
            let controller = segue.destinationViewController as! UserDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            let row = indexPath?.row
            
            let talentModel = talentObject[row!]
            let url = talentModel.url
            let name = talentModel.name
            let ranking = FollowerRanking(name: name, url: url)
            controller.followerRanking = ranking;
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talentObject.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! UITableViewCell

        let object = talentObject[indexPath.row]
        
        cell.textLabel?.text = object.name
        return cell
    }
    
    // MARK: - UITableViewDelegate

}
