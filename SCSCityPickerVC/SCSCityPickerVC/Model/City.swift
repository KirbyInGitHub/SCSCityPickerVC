//
//  City.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 16/7/7.
//  Copyright © 2016年 VSEE. All rights reserved.
//

import UIKit

struct City {
    
    var id: String
    var pid: String
    var name: String
    var spell: String
    var gps1: String?
    var gps2:String?
    var children: [City]?
}

extension City {
    
    /** 首字母获取 */
    var getFirstUpperLetter: String {
        return (self.spell as NSString).substringToIndex(1).uppercaseString
    }
}