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
    
    public mutating func fromJSON(_ jsonObject: AnyObject?) -> Bool {
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
        dict["id"] = id as AnyObject?
        dict["pid"] = pid as AnyObject?
        dict["name"] = name as AnyObject?
        dict["spell"] = spell as AnyObject?
        dict["gps1"] = gps1 as AnyObject?
        dict["gps2"] = gps2 as AnyObject?
        dict["children"] = children?.toJSON() as AnyObject?
        
        return dict as AnyObject
    }
}

extension City {
    
    /** 首字母获取 */
    public var firstUpperLetter: String? {
        
        guard let spell = self.spell, spell.characters.count >= 1 else { return nil }
        
        return nil
        
//        return spell.substringToIndex(spell.characters.index(spell.startIndex, offsetBy: 1)).uppercased()
    }
}
