//
//  SCSCityPickerVC+TableView.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/15.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import Foundation
import UIKit

extension SCSCityPickerVC: UITableViewDataSource,UITableViewDelegate {
    
    var searchH: CGFloat {return 60}
    
    fileprivate var currentCityModel: SCSCityModel? {
        if self.currentCity == nil {return nil}
        return SCSCityModel.findCityModelWithCityName([currentCity], cityModels: cityModels!, isFuzzy: false)?.first
    }
    
    fileprivate var hotCityModels: [SCSCityModel]? {
        if self.hotCities==nil {return nil}
        return SCSCityModel.findCityModelWithCityName(hotCities, cityModels: cityModels!, isFuzzy: false)
    }
    
    fileprivate var historyModels: [SCSCityModel]? {
        if self.selectedCityArray.count == 0 {return nil}
        return SCSCityModel.findCityModelWithCityName(self.selectedCityArray, cityModels: self.cityModels!, isFuzzy: false)
    }
    
    fileprivate var headViewWith: CGFloat{
        return UIScreen.main.bounds.width - 10
    }
    
//    private var headerViewH: CGFloat{
//        
//        let h0: CGFloat = searchH
//        let h1: CGFloat = 100
//        var h2: CGFloat = 100; if self.historyModels?.count > 4 {h2 += 40}
//        var h3: CGFloat = 100; if self.hotCities?.count > 4 {h3 += 40}
//        return h0+h1+h2+h3
//    }
    
    fileprivate var headerViewHight:CGFloat {
        
        var h:CGFloat = 0
        if showSearchBar { h = 80 }
        if showLocation { h = 90 }
        if showHotCity { h = 140 }
        if showHistoryCity { h = 140 }
        
        if showSearchBar && showLocation { h = 170 }
        if showSearchBar && showHistoryCity || showSearchBar && showHotCity { h = 180 }

        if showLocation && showHotCity || showLocation && showHistoryCity { h = 230 }
        if showHistoryCity && showHotCity {h = 280 }
        
        if showSearchBar && showHotCity && showLocation { h = 310 }
        if showSearchBar && showLocation && showHistoryCity { h = 310 }
        if showSearchBar && showHistoryCity && showHotCity { h = 360 }
        
        if showLocation && showHotCity && showHistoryCity { h = 370 }
        
        if showSearchBar && showLocation && showHotCity && showHistoryCity { h = 450 }
        
        return h
    }
    
    fileprivate var sortedCityModles: [SCSCityModel] {
        
        return cityModels!.sorted( by: {  (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
            })
    }
    
    
    /** 计算高度 */
    fileprivate func headItemViewH(_ count: Int) -> CGRect{
        
        let height: CGFloat = count <= 4 ? 96 : 140
        return CGRect(x: 0, y: 0, width: headViewWith, height: height)
    }
    
    
    /** 为tableView准备 */
    func tableViewPrepare(){
        
        self.title = "城市选择"
        
//        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView": tableView]))
        

    }
    
    
    func notiAction(_ noti: Notification){
        
        let userInfo = noti.userInfo as! [String: SCSCityModel]
        let cityModel = userInfo["citiModel"]!
        citySelected(cityModel)
    }
    
    
    
    
    
    /** 定位处理 */
    func locationPrepare(){
        
        if self.currentCity != nil {return}
        
        //定位开始
        let location = LocationManager.sharedInstance
        
        location.autoUpdate = true
        
        location.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            location.stopUpdatingLocation()
            
            location.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { [weak self](reverseGecodeInfo, placemark, error) -> Void in
                
                if error != nil {return}
                if placemark == nil {return}
                let city: NSString = (placemark!.locality! as NSString).replacingOccurrences(of: "市", with: "") as NSString
                self?.currentCity = city as String
                
                })
            
        }
    }
    
    
    
    /** headerView */
    func headerviewPrepare(){
        
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerViewHight))
        
//        let headerView = UIView()
        print(headerViewHight)
        //搜索框
        searchBar = SCSCitySearchBar(frame: CGRect(x: 18, y: 10, width: UIScreen.main.bounds.width - 38, height: 36))
        showSearchBar ? headerView.addSubview(searchBar) : (searchBar.frame = CGRect.zero)

        
        searchBar.searchAction = { (searchText: String) -> Void in
            
            print(searchText)
            
        }
        
        // 开始搜索时候隐藏导航栏
        searchBar.searchBarShouldBeginEditing = {[weak self] in
            
            self?.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self?.searchRVC.cityModels = nil
            
            UIView.animate(withDuration: 0.15, animations: {[weak self] () -> Void in
                self?.searchRVC.view.alpha = 1
                })
        }
        
        
        searchBar.searchBarDidEndditing = {[weak self] in
            
            if self?.searchRVC.cityModels != nil {return}
            
            self?.searchBar.setShowsCancelButton(false, animated: true)
            self?.searchBar.text = ""
            
            self?.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIView.animate(withDuration: 0.14, animations: {[weak self] () -> Void in
                self?.searchRVC.view.alpha = 0
                })
        }
        
        searchBar.searchTextDidChangedAction = {[weak self] (text: String) in
            
            
            
            if text.characters.count == 0 {self?.searchRVC.cityModels = nil;return}
            
            let searchCityModols = SCSCityModel.searchCityModelsWithCondition(text, cities: self!.cityModels!)
            self?.searchRVC.cityModels = searchCityModols
        }
        
        searchBar.searchBarCancelAction = {[weak self] in
            
            self?.searchRVC.cityModels = nil
            self?.searchBar.searchBarDidEndditing?()
        }
        
        //加载搜索结果列表
        searchRVC = SCSCitySearchResultVC(nibName: "SCSCitySearchResultVC", bundle: Bundle.main)
        
        print(searchRVC.view)
        addChildViewController(searchRVC)
        
        view.addSubview(searchRVC.view)
        view.bringSubview(toFront: searchRVC.view)
        
        searchRVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["maskView": searchRVC.view]))
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["maskView": searchRVC.view]))

        searchRVC.view.alpha = 0
        searchRVC.touchBeganAction = {[weak self] in
            self?.searchBar.endEditing(true)
        }
        
        searchRVC.tableViewScrollAction = { [weak self] in
            self?.searchBar.endEditing(true)
        }
        
        searchRVC.tableViewDidSelectedRowAction = {[weak self] (cityModel: SCSCityModel) in
            
            self?.citySelected(cityModel)
        }

        
        let itemView = SCSHeaderItemView.getHeaderItemView("当前城市")
        currentCityItemView = itemView
        var currentCities = [SCSCityModel]()
        
        if self.currentCityModel != nil {
            currentCities.append(self.currentCityModel!)
        }
        
        itemView.cityModles = currentCities
        let y1 = showSearchBar ? searchBar.frame.maxY + 20 : searchBar.frame.maxY
        var frame1 = CGRect(x: 0, y: y1, width: UIScreen.main.bounds.width, height: 90)
        itemView.frame = frame1
        showLocation ? headerView.addSubview(itemView) : (frame1 = CGRect.zero)
        
        
        
        let itemView2 = SCSHeaderItemView.getHeaderItemView("历史选择")
        var historyCityModels: [SCSCityModel] = []
        if self.historyModels != nil {historyCityModels += self.historyModels!}
        itemView2.cityModles = historyCityModels
        var y2:CGFloat = 0
        if !showLocation {
            y2 = searchBar.frame.maxY
        }
        if showLocation {
            y2 = frame1.maxY
        }
        var frame2 = CGRect(x: 0, y: y2, width: UIScreen.main.bounds.width, height: 140)

        itemView2.frame = frame2
        showHistoryCity ? headerView.addSubview(itemView2) : (frame2 = CGRect.zero)
        
        if hotTitle == nil {
            hotTitle = "热门城市"
        }
        
        let itemView3 = SCSHeaderItemView.getHeaderItemView(hotTitle!)
        var hotCityModels: [SCSCityModel] = []
        
        if self.hotCityModels != nil {
            hotCityModels += self.hotCityModels!
        }
        
        itemView3.cityModles = hotCityModels
        
        var y3:CGFloat = 0

        if !showHistoryCity && showLocation {
            y3 = frame1.maxY
        }
        
        if !showHistoryCity && !showLocation && showSearchBar {
            y3 = searchBar.frame.maxY
        }
        
        if showHistoryCity  {
            y3 = frame2.maxY
        }

        var frame3 = CGRect(x: 0, y: y3, width: UIScreen.main.bounds.width, height: 140)
        itemView3.frame = frame3
        showHotCity ?  headerView.addSubview(itemView3) : (frame3 = CGRect.zero)
        
        
        tableView.tableHeaderView = headerView
    }
    
    
    /**  定位到具体的城市了  */
    func getedCurrentCityWithName(_ currentCityName: String){
        
        if self.currentCityModel == nil {return}
        if currentCityItemView?.cityModles.count != 0 {return}
        
        currentCityItemView?.cityModles = [self.currentCityModel!]
    }
    
    
    /** 处理label */
    func labelPrepare(){
        
        indexTitleLabel.backgroundColor = SCSCityPickerVC.rgba(0, g: 0, b: 0, a: 0.4)
        indexTitleLabel.center = self.view.center
        indexTitleLabel.bounds = CGRect(x: 0, y: 0, width: 120, height: 100)
        indexTitleLabel.font = UIFont.boldSystemFont(ofSize: 80)
        indexTitleLabel.textAlignment = NSTextAlignment.center
        indexTitleLabel.textColor = UIColor.white
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCityModles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let children = sortedCityModles[section].children
        
        return children==nil ? 0 : children!.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedCityModles[section].name
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SCSCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexHandle()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        showIndexTitle(title)
        
        self.showTime = 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
            self.showTime = 0.8
            
            })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
            if self.showTime == 0.8 {
                
                self.showTime = 0.6
            }
            })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
            
            if self.showTime == 0.6 {
                
                self.showTime = 0.4
            }
            })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
            
            if self.showTime == 0.4 {
                
                self.showTime = 0.2
            }
            })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] () -> Void in
            
            if self.showTime == 0.2 {
                
                self.dismissIndexTitle()
            }
            
            
            })
        
        return indexTitleIndexArray[index]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func showIndexTitle(_ indexTitle: String){
        
        self.dismissBtn.isEnabled = false
        self.view.isUserInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        self.view.addSubview(indexTitleLabel)
        
    }
    
    func dismissIndexTitle(){
        self.dismissBtn.isEnabled = true
        self.view.isUserInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }
    
    
    /** 选中城市处理 */
    func citySelected(_ cityModel: SCSCityModel){
        
        if let cityIndex = self.selectedCityArray.index(of: cityModel.name) {
            self.selectedCityArray.remove(at: cityIndex)
            
        }else{
            if self.selectedCityArray.count >= 8 {self.selectedCityArray.removeLast()}
        }
        
        self.selectedCityArray.insert(cityModel.name, at: 0)
        
        UserDefaults.standard.set(self.selectedCityArray, forKey: SelectedCityKey)
        
        selectedCityModel?(cityModel)
        
        delegate?.selectedCityModel(self, cityModel: cityModel)
        self.dismiss()
    }
    
    

    /** 处理索引 */
    func indexHandle() -> [String] {
        
        var indexArr: [String] = []
        
        for (index,cityModel) in sortedCityModles.enumerated() {
            let indexString = cityModel.getFirstUpperLetter
            
            if indexArr.contains(indexString) {continue}
            
            indexArr.append(indexString)
            
            indexTitleIndexArray.append(index)
        }
        
        return indexArr
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        indexTitleLabel.center = self.view.center
    }


}

