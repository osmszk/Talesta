//
//  RealmHelper.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/07/08.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import RealmSwift

class RealmHelper: NSObject {
    
    class func makeRealmModelIfNeeded(){
        
        Log.DLog("HOME:\(NSHomeDirectory())")
        
        if self.talentModelAll().count>0{
            Log.DLog("Data exist")
            return
        }
        
        let fileName = "names"
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
//        let data = NSData(contentsOfFile: path)
        var error : NSError
        let text = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        let outputArray = NSMutableArray()
        let lines : [AnyObject]? = text?.componentsSeparatedByString("\n")
        
        let keysStr: AnyObject? = lines?[0]
        let keys = keysStr?.componentsSeparatedByString(",")
        
        let realm = Realm()
        if lines != nil{
            for i in 1..<lines!.count {
                let itemsStr : AnyObject? = lines![i]
                let items = itemsStr?.componentsSeparatedByString(",")
                let content = NSDictionary()
                if items == nil || items?.count<3{
                    continue
                }
                let id: AnyObject = items![0]
                let name: AnyObject = items![1]
                let url: AnyObject = items![2]
                let talentModel : TalentModel = TalentModel()
                talentModel.id = id as! String
                talentModel.name = name as! String
                talentModel.url = url as! String
                realm.write { () -> Void in
                    realm.add(talentModel)
                }
            }
        }
        Log.DLog("convert!")
        
        //ref:http://samekard.blogspot.jp/2014/09/swifterror.html
        //ref:
    }
    
    class func deleteAll(){
        let realm = Realm()
        realm.write { () -> Void in
            realm.deleteAll()
        }
        
    }
    
    class func talentModelAll() -> Results<TalentModel> {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let realm = Realm()
            var results = realm.objects(TalentModel).sorted("name", ascending: true) as Results<TalentModel>
            return results
//        }
    }
    
}
