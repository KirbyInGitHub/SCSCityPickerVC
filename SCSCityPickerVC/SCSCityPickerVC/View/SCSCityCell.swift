//
//  CFCityCell.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

let reuseId = "SCSCityCell"

class SCSCityCell: UITableViewCell {

    var cityModel: SCSCityModel! {
        didSet {
            dataFill()
        }
    }
    
    
    
    class func cityCellInTableView(_ tableView: UITableView) -> SCSCityCell {
        
        //取出cell
        var cityCell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? SCSCityCell
        
        if cityCell == nil {
            cityCell = SCSCityCell(style: UITableViewCellStyle.default, reuseIdentifier: reuseId)}
        
        return cityCell!
    }
    
    
    /** 数据填充 */
    func dataFill(){
        
        self.textLabel?.text = "\(cityModel.name)"
        
    }

    
}

