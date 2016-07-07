//
//  JSONRepresentation.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 16/7/7.
//  Copyright © 2016年 VSEE. All rights reserved.
//

import Foundation

protocol JSONRepresentation {
    
    mutating func fromJSON(jsonObject: AnyObject?) -> Bool
    
    func toJSON() -> AnyObject
    
    init()
}

extension JSONRepresentation {
    
    internal init?(jsonObject: AnyObject?) {
        self.init()
        if !self.fromJSON(jsonObject) {
            return nil
        }
    }
}

extension Array where Element: JSONRepresentation  {
    
    internal init?(jsonObject: AnyObject?) {
        
        guard let array = jsonObject as? [AnyObject] else { return nil }
        
        self = array.flatMap { Element(jsonObject: $0) }
    }
    
    internal func toJSON() -> [AnyObject] {
        
        return self.map { $0.toJSON() }
    }
    
    internal mutating func fromJSON(jsonObject: AnyObject?) -> Bool  {
        
        if let reval = Array<Element>(jsonObject: jsonObject) {
            self = reval
            return true
        } else {
            return false
        }
    }
}