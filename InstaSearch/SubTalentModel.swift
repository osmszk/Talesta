//
//  SubTalentModel.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/07/19.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import RealmSwift

//Realmのオブジェクト
class SubTalentModel: TalentModel {
    dynamic var type : Int = 0
    dynamic var imageUrl : String = ""
    dynamic var officialUrl : String = ""
}
