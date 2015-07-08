//
//  TalentModel.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/07/07.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit
import RealmSwift

//Realmのオブジェクト テキストファイルからオブジェクト化してDBに保存
class TalentModel: Object {
    dynamic var id : String = ""//こっちで適当につけた数値
    dynamic var name : String = ""//芸名
    dynamic var url : String = ""//Talentinstaのユーザー詳細URL
    
}
