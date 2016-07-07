//
//  ViewController.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/15.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SCSCityPickerVCDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func city(sender: UIButton) {
        
        let cityVC = SCSCityPickerVC()
        
        //设置热门城市
//        cityVC.hotCities = ["北京","上海","广州","成都","杭州","重庆"]
        
        // 是否显示搜索框
        cityVC.showSearchBar = true
        
        // 是否展示国外城市
        cityVC.showForeignCity = true
        
        //是否显示热门城市
        cityVC.showHotCity = true
        
        //是否显示历史选择
        cityVC.showHistoryCity = true
        
        //是否显示定位
        cityVC.showLocation = true
        
        
        let navVC = UINavigationController(rootViewController: cityVC)
        presentViewController(navVC, animated: true, completion: nil)
        
        
        //1.闭包,选中了城市
        cityVC.selectedCityModel = {(cityModel: SCSCityModel) in

            print(cityModel.name)

        }
        
        //2.代理,选中了城市
        cityVC.delegate = self
        

    }
    
    /// 代理方式
    func selectedCityModel(cityPicker: SCSCityPickerVC, cityModel: SCSCityModel) {
        
        print(cityModel.id)
    }
    

}

