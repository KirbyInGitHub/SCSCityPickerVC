//
//  SCSCityModel.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/15.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class SCSCityModel: NSObject {
    
    var id: String
    var pid: String
    var name: String
    var spell: String
    var gps1: String?
    var gps2:String?
    var children: [SCSCityModel]?
    
    /** 首字母获取 */
    var getFirstUpperLetter: String {
        return (self.spell as NSString).substring(to: 1).uppercased()
    }
    
    init(id: String, pid: String, name: String, spell: String, gps1: String, gps2:String ){
        
        self.id = id
        self.pid = pid
        self.name = name
        self.spell = spell
        self.gps1 = gps1
        self.gps2 = gps2
    }
  
    /// 从plist文件加载中国城市模型
    ///
    /// - returns: 返回城市模型数组
    class func cityModelsPrepare() -> [SCSCityModel] {
        
        //加载plist，你也可以加载网络数据
        
        let bundleUrl = Bundle.main.path(forResource: "Resource", ofType: "bundle")
        let plistUrl = Bundle(path: bundleUrl!)?.url(forResource: "chinaCity", withExtension: "plist")!
//        let plistUrl = NSBundle.mainBundle().URLForResource("Resource.bundle/chinaCity", withExtension: "plist")!
        let cityArray = NSArray(contentsOf: plistUrl!) as! [NSDictionary]
        
        var cityModels = [SCSCityModel]()
        
        for dict in cityArray{
            let cityModel = parse(dict)
            cityModels.append(cityModel)
        }
        
        return cityModels
    }
    
    /// 从plist文件加载外国城市模型
    ///
    /// - returns: 返回城市模型数组
    class func foreignCityModelsPrepare() -> [SCSCityModel] {
        
        //加载plist，你也可以加载网络数据
        let bundleUrl = Bundle.main.path(forResource: "Resource", ofType: "bundle")
        let plistUrl = Bundle(path: bundleUrl!)?.url(forResource: "foreignCity", withExtension: "plist")!
//        let plistUrl = NSBundle.mainBundle().URLForResource("Resource.bundle/foreignCity", withExtension: "plist")!
        let cityArray = NSArray(contentsOf: plistUrl!) as! [NSDictionary]
        
        var cityModels = [SCSCityModel]()
        
        for dict in cityArray{
            let cityModel = parse(dict)
            cityModels.append(cityModel)
        }
        
        return cityModels
    }
    
    /// 从网络加载城市列表
    ///
    /// - parameter completion: 返回景点数组
    class func getSightsWithCity(_ completion:(_ sights:[SCSCityModel]?) -> ()) {
        
        //以下代码换成自己的网络获取数据的方法
//        SCSNetworkTools.getSightsWithCity { (json, error) -> () in
//            
//            if error != nil || json == nil {
//                return
//            }
//            
//            var cityModels = [SCSCityModel]()
//            
//            for dict in json! {
//                let cityModel = parse(dict)
//                cityModels.append(cityModel)
//            }
//            
//            completion(sights: cityModels)
        
//        }
    }
    
    /// 进行字典转模型
    ///
    /// - parameter dict: 字典
    ///
    /// - returns: 返回城市模型
    class func parse(_ dict: NSDictionary) -> SCSCityModel {
        
        let id = dict["id"] as! String
        let pid = dict["pid"] as! String
        let name = dict["name"] as! String
        let spell = dict["spell"] as! String
        let gps1 = dict["gps1"] as? String ?? ""
        let gps2 = dict["gps2"] as? String ?? ""
        
        let cityModel = SCSCityModel(id: id, pid: pid, name: name, spell: spell ,gps1: gps1, gps2:gps2)
        
        let children = dict["children"]
        
        if children != nil { //有子级
            
            var childrenArr: [SCSCityModel] = []
            for childDict in children as! NSArray {
                
                let childrencityModel = parse(childDict as! NSDictionary)
                
                childrenArr.append(childrencityModel)
            }
            
            cityModel.children = childrenArr
        }
        
        return cityModel
    }
    

    
    
    /// 搜索城市模型
    ///
    /// - parameter cityNames:  需要搜索的城市名称
    /// - parameter cityModels: 搜索的城市模型
    /// - parameter isFuzzy:    是否是精确搜索
    ///
    /// - returns: 返回搜索的结果城市数组
    class func findCityModelWithCityName(_ cityNames: [String]?, cityModels: [SCSCityModel], isFuzzy: Bool) -> [SCSCityModel]? {
        
        if cityNames == nil {return nil}
        
        var destinationModels = [SCSCityModel]()
        
        for name in cityNames!{
            
            for cityModel in cityModels{ //省
                
                if cityModel.children == nil {continue}
                
                for cityModel2 in cityModel.children! { //市
                    
                    if !isFuzzy { //精确查找
                        
                        if cityModel2.name != name {continue}
                        
                        destinationModels.append(cityModel2)
                        
                    }else{//模糊搜索
                        
                        let checkName = (name as NSString).lowercased
                        
                        if (cityModel2.name as NSString).range(of: name).length > 0 || ((cityModel2.spell as NSString).lowercased as NSString).range(of: checkName).length > 0{
                            destinationModels.append(cityModel2)
                            
                        }
                    }
                }
            }
            
        }
        
        return destinationModels
    }
    
    /// 搜索城市模型
    ///
    /// - parameter condition: 查询的条件
    /// - parameter cities:    城市模型
    ///
    /// - returns: 返回搜索后的城市模型数组
    class func searchCityModelsWithCondition(_ condition: String, cities: [SCSCityModel]) -> [SCSCityModel]?{
        
        return findCityModelWithCityName([condition], cityModels: cities, isFuzzy: true)
    }
    
}







