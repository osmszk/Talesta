//
//  SearchViewController.swift
//  InstaSearch
//
//  Created by Osamu Suzuki on 2015/05/18.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let talentModels = RealmHelper.talentModelAll()
    let talentSectionTitles = RealmHelper.talentSectionTitles()
    var cellDataIndexTalents : [IndexTitleTalent] = []
    var filteredTableData :[TalentModel] = []
    var isFiltered : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "芸能人検索"
        self.navigationController?.navigationBar.translucent = Const.NAVI_BAR_TRANSLUCENT
        self.tableView.sectionIndexColor = Const.APP_COLOR1;
        
        self.cellDataIndexTalents = RealmHelper.cellDataIndexTalents(self.talentModels)
        
        let label = UILabel()
        label.text = "芸能人検索"
        label.textColor = Const.APP_COLOR8
        label.font = UIFont.boldSystemFontOfSize(18)
        label.sizeToFit()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        label.addGestureRecognizer(gestureRecognizer)
        
        label.userInteractionEnabled = true
        self.navigationItem.titleView = label
        
    }
    func tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    
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
            self.searchBar.resignFirstResponder()
            
            let controller = segue.destinationViewController as! UserDetailViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow(){
                if self.isFiltered{
                    let talentModel = self.filteredTableData[indexPath.row]
                    let url = talentModel.url
                    let name = talentModel.name
                    let ranking = Talentinsta(name: name, url: url)
                    controller.followerRanking = ranking;
                }else{
                    let indexTalent = self.cellDataIndexTalents[indexPath.section]
                    let talentModel = indexTalent.talents[indexPath.row]
                    let url = talentModel.url
                    let name = talentModel.name
                    let ranking = Talentinsta(name: name, url: url)
                    controller.followerRanking = ranking;
                }
            }
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.isFiltered{
            return 1
        }else{
            return self.cellDataIndexTalents.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltered{
            return self.filteredTableData.count
        }else{
            let indexTalent = self.cellDataIndexTalents[section]
            return indexTalent.talents.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! UITableViewCell

        if self.isFiltered{
            let talent  = self.filteredTableData[indexPath.row]
            cell.textLabel?.text = talent.name
        }else{
            let indexTalent = self.cellDataIndexTalents[indexPath.section]
            let talent = indexTalent.talents[indexPath.row]
            cell.textLabel?.text = talent.name
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?    {
        if self.isFiltered {
            return ""
        }else{
            let indexTalent = self.cellDataIndexTalents[section]
            return indexTalent.indexTitle
        }
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if self.isFiltered {
            return nil
        }else{
            return self.talentSectionTitles
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if self.self.isFiltered {
            return 0
        }else{
            return (self.talentSectionTitles as NSArray).indexOfObject(title)
        }
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText as NSString).length == 0 {
            self.isFiltered = false
            searchBar.resignFirstResponder()
        }else{
            self.isFiltered = true
            self.filteredTableData = []
            
            for talentModel in self.talentModels{
               let range = talentModel.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                if range != nil{
                    self.filteredTableData.append(talentModel)
                }
            }
        }
        self.tableView.reloadData()
    }


}
