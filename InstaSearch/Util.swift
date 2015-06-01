//
//  Util.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/01.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class Util{

    static let KEY_TRACKING_VERSION : String = "keyTrackingVersion"
    
    class func appVersionString() -> String{
        //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        let infoDic : Dictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
        return (infoDic["CFBundleVersion"] as! String)
//        return NSBundle.mainBundle().infoDictionary.objectForKey("CFBundleVersion")
    }
    
    ////////////////////////
    
    class func saveObject(obj:AnyObject?, forKey key: String){
        NSUserDefaults.standardUserDefaults().setObject(obj, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func loadObject(key:String) -> AnyObject?{
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func saveInteger(val:NSInteger, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setInteger(val, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func loadInteger(key:String) -> NSInteger{
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    class func saveBool(val:Bool, forKey key:String){
        NSUserDefaults.standardUserDefaults().setBool(val, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func loadBool(key:String) -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    class func remove(key:String){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
    
    class func clearAllSavedData() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
    }
    
    class func saveWithArchiving(obj:AnyObject, forKey key:String){
        let data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func loadWithUnarchiving(key:String) -> AnyObject? {
        var data : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
        
        if data != nil{
            return NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData)
        }
        return nil
    }
    
    class func saveTrackingAppVersion(){
        NSUserDefaults.standardUserDefaults().setObject(Util.appVersionString(), forKey: KEY_TRACKING_VERSION)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    
    
}