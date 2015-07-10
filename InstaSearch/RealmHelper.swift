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
    
    
    class func talentSectionTitles() -> [String]{
        return ["0","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q" ,"R", "S", "T", "U", "V", "W", "X", "Y", "Z","#"]
    }
    
    class func cellDataIndexTalents(talentModels:Results<TalentModel>) -> [IndexTitleTalent]{
        
        //TODO:ロジック
        
        
        var cellDataIndexArtists : [IndexTitleTalent] = []

        var talentsNum : [TalentModel]  = []
        var talentsA : [TalentModel] =  []
        var talentsB : [TalentModel] =  []
        var talentsC : [TalentModel] =  []
        var talentsD : [TalentModel] =  []
        var talentsE : [TalentModel] =  []
        var talentsF : [TalentModel] =  []
        var talentsG : [TalentModel] =  []
        var talentsH : [TalentModel] =  []
        var talentsI : [TalentModel] =  []
        var talentsJ : [TalentModel] =  []
        var talentsK : [TalentModel] =  []
        var talentsL : [TalentModel] =  []
        var talentsM : [TalentModel] =  []
        var talentsN : [TalentModel] =  []
        var talentsO : [TalentModel] =  []
        var talentsP : [TalentModel] =  []
        var talentsQ : [TalentModel] =  []
        var talentsR : [TalentModel] =  []
        var talentsS : [TalentModel] =  []
        var talentsT : [TalentModel] =  []
        var talentsU : [TalentModel] =  []
        var talentsV : [TalentModel] =  []
        var talentsW : [TalentModel] =  []
        var talentsX : [TalentModel] =  []
        var talentsY : [TalentModel] =  []
        var talentsZ : [TalentModel] =  []
        var talentsOther : [TalentModel] =  []
        
        for talentModel in talentModels {
            
            let name = talentModel.name
            let checkIndexString = (name as NSString).substringToIndex(1)
            
            if self.isDigit(checkIndexString) {
                //頭文字が数字
                talentsNum.append(talentModel)
            }else if (checkIndexString == "A"){
                talentsA.append(talentModel)
            }else if (checkIndexString  == "B" ){
                talentsB.append(talentModel)
            }else if (checkIndexString  == "C" ){
                talentsC.append(talentModel)
            }else if (checkIndexString  == "D" ){
                talentsD.append(talentModel)
            }else if (checkIndexString  == "E" ){
                talentsE.append(talentModel)
            }else if (checkIndexString  == "F" ){
                talentsF.append(talentModel)
            }else if (checkIndexString  == "G" ){
                talentsG.append(talentModel)
            }else if (checkIndexString  == "H" ){
                talentsH.append(talentModel)
            }else if (checkIndexString  == "I" ){
                talentsI.append(talentModel)
            }else if (checkIndexString  == "J" ){
                talentsJ.append(talentModel)
            }else if (checkIndexString  == "K" ){
                talentsK.append(talentModel)
            }else if (checkIndexString  == "L" ){
                talentsL.append(talentModel)
            }else if (checkIndexString  == "M" ){
                talentsM.append(talentModel)
            }else if (checkIndexString  == "N" ){
                talentsN.append(talentModel)
            }else if (checkIndexString  == "O" ){
                talentsO.append(talentModel)
            }else if (checkIndexString  == "P" ){
                talentsP.append(talentModel)
            }else if (checkIndexString  == "Q" ){
                talentsQ.append(talentModel)
            }else if (checkIndexString  == "R" ){
                talentsR.append(talentModel)
            }else if (checkIndexString  == "S" ){
                talentsS.append(talentModel)
            }else if (checkIndexString  == "T" ){
                talentsT.append(talentModel)
            }else if (checkIndexString  == "U" ){
                talentsU.append(talentModel)
            }else if (checkIndexString  == "V" ){
                talentsV.append(talentModel)
            }else if (checkIndexString  == "W" ){
                talentsW.append(talentModel)
            }else if (checkIndexString  == "X" ){
                talentsX.append(talentModel)
            }else if (checkIndexString  == "Y" ){
                talentsY.append(talentModel)
            }else if (checkIndexString  == "Z" ){
                talentsZ.append(talentModel)
            }else{
                //頭文字がその他（ひらがなとか漢字）
                talentsOther.append(talentModel)
            }
        }
        
        for indexTitle in self.talentSectionTitles() {
            let indexTitleArtist = IndexTitleTalent()
            indexTitleArtist.indexTitle = indexTitle;
            if (indexTitle == "0") {
                indexTitleArtist.talents = talentsNum;
            }else if (indexTitle == "A") {
                indexTitleArtist.talents = talentsA;
            }else if (indexTitle == "B") {
                indexTitleArtist.talents = talentsB;
            }else if (indexTitle == "C") {
                indexTitleArtist.talents = talentsC;
            }else if (indexTitle == "D") {
                indexTitleArtist.talents = talentsD;
            }else if (indexTitle == "E") {
                indexTitleArtist.talents = talentsE;
            }else if (indexTitle == "F") {
                indexTitleArtist.talents = talentsF;
            }else if (indexTitle == "G") {
                indexTitleArtist.talents = talentsG;
            }else if (indexTitle == "H") {
                indexTitleArtist.talents = talentsH;
            }else if (indexTitle == "I") {
                indexTitleArtist.talents = talentsI;
            }else if (indexTitle == "J") {
                indexTitleArtist.talents = talentsJ;
            }else if (indexTitle == "K") {
                indexTitleArtist.talents = talentsK;
            }else if (indexTitle == "L") {
                indexTitleArtist.talents = talentsL;
            }else if (indexTitle == "M") {
                indexTitleArtist.talents = talentsM;
            }else if (indexTitle == "N") {
                indexTitleArtist.talents = talentsN;
            }else if (indexTitle == "O") {
                indexTitleArtist.talents = talentsO;
            }else if (indexTitle == "P") {
                indexTitleArtist.talents = talentsP;
            }else if (indexTitle == "Q") {
                indexTitleArtist.talents = talentsQ;
            }else if (indexTitle == "R") {
                indexTitleArtist.talents = talentsR;
            }else if (indexTitle == "S") {
                indexTitleArtist.talents = talentsS;
            }else if (indexTitle == "T") {
                indexTitleArtist.talents = talentsT;
            }else if (indexTitle == "U") {
                indexTitleArtist.talents = talentsU;
            }else if (indexTitle == "V") {
                indexTitleArtist.talents = talentsV;
            }else if (indexTitle == "W") {
                indexTitleArtist.talents = talentsW;
            }else if (indexTitle == "X") {
                indexTitleArtist.talents = talentsX;
            }else if (indexTitle == "Y") {
                indexTitleArtist.talents = talentsY;
            }else if (indexTitle == "Z") {
                indexTitleArtist.talents = talentsZ;
            }else{
                indexTitleArtist.talents = talentsOther;
            }
            cellDataIndexArtists.append(indexTitleArtist)
            // addObject(indexTitleArtist)
        }
        return cellDataIndexArtists as Array

    }

    class func isDigit(string:String) ->Bool{

        for tempChar in string.unicodeScalars {
            let s = String(tempChar).unicodeScalars
            let uni = s[s.startIndex]
            
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            let isADigit = digits.longCharacterIsMember(uni.value)
            if isADigit{
                Log.DLog("is digit true \(string)")
                return true
            }
        }
        return false
    }
}
