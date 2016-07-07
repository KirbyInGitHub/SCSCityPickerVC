//
//  CityManager.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 16/7/7.
//  Copyright © 2016年 VSEE. All rights reserved.
//

import Foundation

public enum CityType {
    case china
    case foreign
    case chinaAndForeign
    case network
}

extension CityType {
    
    private var chinaCitys: [City]? {
        guard let bundleUrl = NSBundle.mainBundle().pathForResource("Resource", ofType: "bundle"),
            let plistUrl = NSBundle(path: bundleUrl)?.URLForResource("chinaCity", withExtension: "plist") else {
            return nil
        }
        let plistArray = NSArray(contentsOfURL: plistUrl)
        
        return [City](jsonObject: plistArray)
    }
    
    private var foreignCitys: [City]? {
        guard let bundleUrl = NSBundle.mainBundle().pathForResource("Resource", ofType: "bundle"),
            let plistUrl = NSBundle(path: bundleUrl)?.URLForResource("foreignCity", withExtension: "plist") else {
                return nil
        }
        let plistArray = NSArray(contentsOfURL: plistUrl)
        
        return [City](jsonObject: plistArray)
    }
    
    public var citys: ([City]?, [City]?) {
        switch self {
        case .china: return (chinaCitys, nil)
        case .foreign: return (nil, foreignCitys)
        case .chinaAndForeign : return (chinaCitys, foreignCitys)
        case .network: return (nil, nil)
        }
    }
}

public struct CityManager {
    
    public var cityType: CityType = .china
    
    public var activationCityType: CityType = .china
    
    public func findCity(withCityNames cityNames: [String]?, isFuzzy: Bool = true) -> [City]? {
        
        guard let cityNames = cityNames else { return nil }
        
        var destinationCitys = [City]()
        
        let activationCity: [City]
        
        switch activationCityType {
        case .china:
            guard let citys = activationCityType.chinaCitys else { return nil }
            activationCity = citys
        case .foreign:
            guard let citys = activationCityType.foreignCitys else { return nil }
            activationCity = citys
        case .chinaAndForeign, .network: return nil
        }
        
        let childrenCitys = activationCity.flatMap { $0.children }.flatMap { $0 }
        
        for name in cityNames {
            for city in childrenCitys {
                if !isFuzzy {
                    if city.name != name { continue }
                    destinationCitys.append(city)
                    
                } else {
                    if city.name?.containsString(name.lowercaseString) == true ||
                        city.spell?.lowercaseString.containsString(name.lowercaseString) == true {
                        destinationCitys.append(city)
                    }
                }
            }
        }
        
        return destinationCitys
    }
}
