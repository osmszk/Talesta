//
//  Util.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/01.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class Util{

    static let KEY_TRACKING_VERSION = "keyTrackingVersion"
    
    enum AppVersionState: Int {
        case NotChanged
        case First
        case BumpedUp
    }
    
    class func osVersion() -> Float{
        return NSString(string: UIDevice.currentDevice().systemVersion).floatValue
    }
    
    class func appVersionString() -> String{
        let infoDic : Dictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
        return infoDic["CFBundleVersion"] as! String
    }
    
    class func trackingAppVersion() -> String?{
        return NSUserDefaults.standardUserDefaults().stringForKey(KEY_TRACKING_VERSION);
    }
    
    class func appVersionNumber() -> NSNumber{
        return Util.convertToNumberVersion(Util.appVersionString());
    }
    
    class func appVersionState() -> AppVersionState{
        let trackingAppVersion = Util.trackingAppVersion()
        let currentAppVersion = Util.appVersionString();
        if (trackingAppVersion == nil) {
            return AppVersionState.First
        }
        
        if (trackingAppVersion != currentAppVersion) {
            return AppVersionState.BumpedUp;
        }
        
        return AppVersionState.NotChanged;
    }
    
    class func displaySize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    class func displayFrame() -> CGRect{
        return CGRectMake(0, 0, Util.displaySize().width, Util.displaySize().height);
    }
    
    class func displayCenter() -> CGPoint {
        return CGPointMake(Util.displaySize().width/2.0, Util.displaySize().height/2.0);
    }
    
    ////////////////////////
    
    class func convertToNumberVersion(appVersionString:String) -> NSNumber{
        let array : NSArray = appVersionString.componentsSeparatedByString(".")
        var resultString : NSString = ""
        if array.count == 2{
            resultString = NSString(format: "%d%02d", array[0].integerValue, array[1].integerValue)
            return NSNumber(integer: resultString.integerValue)
        }else if array.count == 3{
            resultString = NSString(format: "%d%02d%02d",array[0].integerValue, array[1].integerValue, array[2].integerValue)
            return NSNumber(integer: resultString.integerValue)
        }else{
            return NSNumber(integer: appVersionString.toInt()!)
        }
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