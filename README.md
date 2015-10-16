# SCSCityPickerVC
一款支持国内外城市的选择器

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
        cityVC.selectedCityModel = {[weak self] (cityModel: SCSCityModel) in

            print(cityModel.name)

        }
        
        //2.代理,选中了城市
        cityVC.delegate = self
        
        
  /// 代理方式
    func selectedCityModel(cityPicker: SCSCityPickerVC, cityModel: SCSCityModel) {
        
        print(cityModel.id)
    }

