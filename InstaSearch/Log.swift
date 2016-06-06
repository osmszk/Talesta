//
//  Log.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/01.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import Foundation

class Log {
    
    class func DLog(message: String, function: String = #function) {
        #if DEBUG
            print("\(function): \(message)")
        #endif
    }
}