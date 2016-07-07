//
//  City.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 16/7/7.
//  Copyright © 2016年 VSEE. All rights reserved.
//

import UIKit

public struct City {
    
    var id: String?
    var pid: String?
    var name: String?
    var spell: String?
    var gps1: String?
    var gps2:String?
    var children: [City]?
}

extension City: JSONRepresentation {
    
    public mutating func fromJSON(jsonObject: AnyObject?) -> Bool {
        guard let dict = jsonObject as? [String: AnyObject] else { return false }

        id = dict["id"] as? String
        pid = dict["pid"] as? String
        name = dict["name"] as? String
        spell = dict["spell"] as? String
        gps1 = dict["gps1"] as? String
        gps2 = dict["gps2"] as? String
        children = [City](jsonObject: dict["children"])
        
        return true
    }
    
    public func toJSON() -> AnyObject {
        
        var dict = [String: AnyObject]()
        dict["id"] = id
        dict["pid"] = pid
        dict["name"] = name
        dict["spell"] = spell
        dict["gps1"] = gps1
        dict["gps2"] = gps2
        dict["children"] = children?.toJSON()
        
        return dict
    }
}

extension City {
    
    /** 首字母获取 */
    public var firstUpperLetter: String? {
        
        guard let spell = self.spell where spell.characters.count >= 1 else { return nil }
        
        return spell.substringToIndex(spell.startIndex.advancedBy(1)).uppercaseString
    }
}