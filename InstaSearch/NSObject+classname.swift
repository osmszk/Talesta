//
//  NSObject+classname.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2016/01/23.
//  Copyright © 2016年 Plegineer Inc. All rights reserved.
//

import Foundation

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}
