//
//  TalentModel.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/07/07.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import RealmSwift

//Realmのオブジェクト
class TalentModel: Object {
    dynamic var id : String = ""
    dynamic var name : String = ""
    dynamic var url : String = ""
    
//    class func talentWithDic(dic : NSDictionary) -> TalentModel{
//        let talent : TalentModel = TalentModel()
//        talent.id = dic["id"] as! String
//        talent.name = dic["name"] as! String
//        talent.url = dic["url"] as! String
//        return talent
//    }
}
