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
        
        Log.DLog("[start]make realm HOME:\(NSHomeDirectory())")
        
        let start = NSDate()
        
        if self.talentModelAll().count>0{
            Log.DLog("Data exist \(NSDate().timeIntervalSinceDate(start))")
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
        realm.beginWrite()
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

                realm.create(TalentModel.self, value: [
                    "id": id as! String,
                    "name": name as! String,
                    "url": url as! String
                    ])
            }
        }
        realm.commitWrite()
        Log.DLog("[end] convert! \(NSDate().timeIntervalSinceDate(start)))")
        
        //ref:http://samekard.blogspot.jp/2014/09/swifterror.html
        //ref:
    }
    
    class func makeSubRealmModelIfNeeded(fileName:String){
        
        Log.DLog("[start] make SUB realm HOME:\(NSHomeDirectory())")
        
        let start = NSDate()
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
        //        let data = NSData(contentsOfFile: path)
        var error : NSError
        let text = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        let outputArray = NSMutableArray()
        let lines : [AnyObject]? = text?.componentsSeparatedByString("\n")
        
        let keysStr: AnyObject? = lines?[0]
        let keys = keysStr?.componentsSeparatedByString(",")
        
        let realm = Realm()
        realm.beginWrite()
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
                let imageUrl : AnyObject = items![3]
                let officialUrl : AnyObject = items![4]
                Log.DLog("i:\(i)")
                if(fileName == "terracehouse"){
                    let talentModel : TerracehouseTalentModel = TerracehouseTalentModel()
                    realm.create(TerracehouseTalentModel.self, value: [
                        "id": id as! String,
                        "name": name as! String,
                        "url": url as! String,
                        "imageUrl": imageUrl as! String,
                        "officialUrl": officialUrl as! String
                        ])
                }else if(fileName == "korean"){
                    let talentModel : KoreanTalentModel = KoreanTalentModel()
                    realm.create(KoreanTalentModel.self, value: [
                        "id": id as! String,
                        "name": name as! String,
                        "url": url as! String,
                        "imageUrl": imageUrl as! String,
                        "officialUrl": officialUrl as! String
                        ])
                }
            }
        }
        realm.commitWrite()
        Log.DLog("[end]terrace convert! \(NSDate().timeIntervalSinceDate(start))")
        
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
        let start = NSDate()
        let realm = Realm()
        var results = realm.objects(TalentModel).sorted("name", ascending: true) as Results<TalentModel>
        Log.DLog("talentModelAll \(NSDate().timeIntervalSinceDate(start))")
        return results
    }
    
    class func terraceHousetalentModelAll() -> Results<TerracehouseTalentModel> {
        let realm = Realm()
        var results = realm.objects(TerracehouseTalentModel) as Results<TerracehouseTalentModel>
        return results
    }
    
    class func koreantalentModelAll() -> Results<KoreanTalentModel> {
        let realm = Realm()
        var results = realm.objects(KoreanTalentModel) as Results<KoreanTalentModel>
        return results
    }
    
    
    
    class func talentSectionTitles() -> [String]{
        return ["0","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q" ,"R", "S", "T", "U", "V", "W", "X", "Y", "Z","あ","ア","漢","#"]
    }
    
    class func cellDataIndexTalents(talentModels:Results<TalentModel>) -> [IndexTitleTalent]{
        
        var cellDataIndexArtists : [IndexTitleTalent] = []

        let start = NSDate()
        
        for indexTitle in self.talentSectionTitles() {
            let indexTitleArtist = IndexTitleTalent()
            indexTitleArtist.indexTitle = indexTitle;
            
            var talentsGroup : [TalentModel] = []
            for talentModel in talentModels {
                
                let name = talentModel.name
                let nameHead = (name as NSString).substringToIndex(1).uppercaseString
                
                if self.shouldAddGroup(nameHead, indexTitle: indexTitle){
                    talentsGroup.append(talentModel)
                }
            }
            indexTitleArtist.talents = talentsGroup
            cellDataIndexArtists.append(indexTitleArtist)
        }
        //TODO:ボトルネックなおす　3.17秒かかる
        Log.DLog("cellDataIndexTalents :\(NSDate().timeIntervalSinceDate(start))")
        
        return cellDataIndexArtists as Array
    }
    
    
    
    
    class func shouldAddGroup(nameHead:String ,indexTitle:String)->Bool {
        //http://qiita.com/hiroo0529/items/c49416c7587daa61ff90
        if indexTitle == "0"{
            return self.isDigit(nameHead)
        }else if indexTitle >= "A" && indexTitle <= "Z"{
            return nameHead == indexTitle
        }else if indexTitle == "あ"{
            return self.isIncludeHiragana(nameHead)
        }else if indexTitle == "ア"{
            return self.isIncludeKatakana(nameHead)
        }else  if indexTitle == "漢"{
            return !self.isDigit(nameHead)
                && !self.isAlphabet(nameHead)
                && !self.isIncludeHiragana(nameHead)
                && !self.isIncludeKatakana(nameHead)
                && nameHead != "["
        }else if indexTitle == "#"{
            return nameHead == "["
        }
        return false
    }
    
    //http://qiita.com/yasumodev/items/4f1e859da4986aaca55e
    class func isAlphabet(string:String) -> Bool {
        return string >= "A" && string <= "Z"
    }
    
    //http://qiita.com/MIN/items/a37b6e1ce0f41872fd2c
    class func isIncludeKatakana(string:String) -> Bool{
        for c in string.unicodeScalars {
            if c.value >= 0x30A1 && c.value <= 0x30F6{
                return true
            }
        }
        return false
    }
    
    class func isIncludeHiragana(string:String) -> Bool{
        for c in string.unicodeScalars {
            if c.value >= 0x3041 && c.value <= 0x3096{
                return true
            }
        }
        return false
    }

    class func isDigit(string:String) -> Bool{

        for c in string.unicodeScalars {
            let s = String(c).unicodeScalars
            let uni = s[s.startIndex]
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            let isADigit = digits.longCharacterIsMember(uni.value)
            if isADigit{
//                Log.DLog("is digit true \(string)")
                return true
            }
        }
        return false
    }
}
