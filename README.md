# SCSCityPickerVC<br>
一款支持国内外城市的选择器<br>
```Swift
let cityVC = SCSCityPickerVC()
```
设置热门城市<br>
```Swift
cityVC.hotCities = ["北京","上海","广州","成都","杭州","重庆"]
```
是否显示搜索框<br>
```Swift
cityVC.showSearchBar = true
```
是否展示国外城市<br>
```Swift
cityVC.showForeignCity = true
```
是否显示热门城市<br>
```Swift
cityVC.showHotCity = true
```
是否显示历史选择<br>
```Swift
cityVC.showHistoryCity = true
```
是否显示定位<br>
```Swift
cityVC.showLocation = true
```
```Swift
let navVC = UINavigationController(rootViewController: cityVC)
presentViewController(navVC, animated: true, completion: nil)
```
<br>  
1.闭包,选中了城市<br>
```Swift
cityVC.selectedCityModel = {[weak self] (cityModel: SCSCityModel) in
        print(cityModel.name)
}
```
<br>      
2.代理,选中了城市<br>
```Swift
cityVC.delegate = self
```
<br>
代理方式<br>
```Swift
func selectedCityModel(cityPicker: SCSCityPickerVC, cityModel: SCSCityModel) {
        print(cityModel.id)
}
```

