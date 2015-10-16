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
    
    private var currentCityModel: SCSCityModel? {
        if self.currentCity == nil {return nil}
        return SCSCityModel.findCityModelWithCityName([currentCity], cityModels: cityModels!, isFuzzy: false)?.first
    }
    
    private var hotCityModels: [SCSCityModel]? {
        if self.hotCities==nil {return nil}
        return SCSCityModel.findCityModelWithCityName(hotCities, cityModels: cityModels!, isFuzzy: false)
    }
    
    private var historyModels: [SCSCityModel]? {
        if self.selectedCityArray.count == 0 {return nil}
        return SCSCityModel.findCityModelWithCityName(self.selectedCityArray, cityModels: self.cityModels!, isFuzzy: false)
    }
    
    private var headViewWith: CGFloat{
        return UIScreen.mainScreen().bounds.width - 10
    }
    
//    private var headerViewH: CGFloat{
//        
//        let h0: CGFloat = searchH
//        let h1: CGFloat = 100
//        var h2: CGFloat = 100; if self.historyModels?.count > 4 {h2 += 40}
//        var h3: CGFloat = 100; if self.hotCities?.count > 4 {h3 += 40}
//        return h0+h1+h2+h3
//    }
    
    private var headerViewHight:CGFloat {
        
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
    
    private var sortedCityModles: [SCSCityModel] {
        
        return cityModels!.sort( {  (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
            })
    }
    
    
    /** 计算高度 */
    private func headItemViewH(count: Int) -> CGRect{
        
        let height: CGFloat = count <= 4 ? 96 : 140
        return CGRectMake(0, 0, headViewWith, height)
    }
    
    
    /** 为tableView准备 */
    func tableViewPrepare(){
        
        self.title = "城市选择"
        
//        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView": tableView]))
        

    }
    
    
    func notiAction(noti: NSNotification){
        
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
                let city: NSString = (placemark!.locality! as NSString).stringByReplacingOccurrencesOfString("市", withString: "")
                self?.currentCity = city as String
                
                })
            
        }
    }
    
    
    
    /** headerView */
    func headerviewPrepare(){
        
                let headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, headerViewHight))
        
//        let headerView = UIView()
        print(headerViewHight)
        //搜索框
        searchBar = SCSCitySearchBar(frame: CGRectMake(18, 10, UIScreen.mainScreen().bounds.width - 38, 36))
        showSearchBar ? headerView.addSubview(searchBar) : (searchBar.frame = CGRectZero)

        
        searchBar.searchAction = { (searchText: String) -> Void in
            
            print(searchText)
            
        }
        
        // 开始搜索时候隐藏导航栏
        searchBar.searchBarShouldBeginEditing = {[weak self] in
            
            self?.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self?.searchRVC.cityModels = nil
            
            UIView.animateWithDuration(0.15, animations: {[weak self] () -> Void in
                self?.searchRVC.view.alpha = 1
                })
        }
        
        
        searchBar.searchBarDidEndditing = {[weak self] in
            
            if self?.searchRVC.cityModels != nil {return}
            
            self?.searchBar.setShowsCancelButton(false, animated: true)
            self?.searchBar.text = ""
            
            self?.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIView.animateWithDuration(0.14, animations: {[weak self] () -> Void in
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
        searchRVC = SCSCitySearchResultVC(nibName: "SCSCitySearchResultVC", bundle: NSBundle.mainBundle())
        
        print(searchRVC.view)
        addChildViewController(searchRVC)
        
        view.addSubview(searchRVC.view)
        view.bringSubviewToFront(searchRVC.view)
        
        searchRVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["maskView": searchRVC.view]))
        view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["maskView": searchRVC.view]))

        searchRVC.view.alpha = 0
        searchRVC.touchBeganAction = {[weak self] in
            searchBar.endEditing(true)
        }
        
        searchRVC.tableViewScrollAction = { [weak self] in
            searchBar.endEditing(true)
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
        let y1 = showSearchBar ? CGRectGetMaxY(searchBar.frame) + 20 : CGRectGetMaxY(searchBar.frame)
        var frame1 = CGRectMake(0, y1, UIScreen.mainScreen().bounds.width, 90)
        itemView.frame = frame1
        showLocation ? headerView.addSubview(itemView) : (frame1 = CGRectZero)
        
        
        
        let itemView2 = SCSHeaderItemView.getHeaderItemView("历史选择")
        var historyCityModels: [SCSCityModel] = []
        if self.historyModels != nil {historyCityModels += self.historyModels!}
        itemView2.cityModles = historyCityModels
        var y2:CGFloat = 0
        if !showLocation {
            y2 = CGRectGetMaxY(searchBar.frame)
        }
        if showLocation {
            y2 = CGRectGetMaxY(frame1)
        }
        var frame2 = CGRectMake(0, y2, UIScreen.mainScreen().bounds.width, 140)

        itemView2.frame = frame2
        showHistoryCity ? headerView.addSubview(itemView2) : (frame2 = CGRectZero)
        
        
        
        let itemView3 = SCSHeaderItemView.getHeaderItemView("热门城市")
        var hotCityModels: [SCSCityModel] = []
        
        if self.hotCityModels != nil {
            hotCityModels += self.hotCityModels!
        }
        
        itemView3.cityModles = hotCityModels
        
        var y3:CGFloat = 0

        if !showHistoryCity && showLocation {
            y3 = CGRectGetMaxY(frame1)
        }
        
        if !showHistoryCity && !showLocation && showSearchBar {
            y3 = CGRectGetMaxY(searchBar.frame)
        }
        
        if showHistoryCity  {
            y3 = CGRectGetMaxY(frame2)
        }

        var frame3 = CGRectMake(0, y3, UIScreen.mainScreen().bounds.width, 140)
        itemView3.frame = frame3
        showHotCity ?  headerView.addSubview(itemView3) : (frame3 = CGRectZero)
        
        
        tableView.tableHeaderView = headerView
    }
    
    
    /**  定位到具体的城市了  */
    func getedCurrentCityWithName(currentCityName: String){
        
        if self.currentCityModel == nil {return}
        if currentCityItemView?.cityModles.count != 0 {return}
        
        currentCityItemView?.cityModles = [self.currentCityModel!]
    }
    
    
    /** 处理label */
    func labelPrepare(){
        
        indexTitleLabel.backgroundColor = SCSCityPickerVC.rgba(0, g: 0, b: 0, a: 0.4)
        indexTitleLabel.center = self.view.center
        indexTitleLabel.bounds = CGRectMake(0, 0, 120, 100)
        indexTitleLabel.font = UIFont.boldSystemFontOfSize(80)
        indexTitleLabel.textAlignment = NSTextAlignment.Center
        indexTitleLabel.textColor = UIColor.whiteColor()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedCityModles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let children = sortedCityModles[section].children
        
        return children==nil ? 0 : children!.count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedCityModles[section].name
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = SCSCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return indexHandle()
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        showIndexTitle(title)
        
        self.showTime = 1
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            
            self.showTime = 0.8
            
            })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            
            if self.showTime == 0.8 {
                
                self.showTime = 0.6
            }
            })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.6 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            
            
            if self.showTime == 0.6 {
                
                self.showTime = 0.4
            }
            })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            
            
            if self.showTime == 0.4 {
                
                self.showTime = 0.2
            }
            })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] () -> Void in
            
            if self.showTime == 0.2 {
                
                self.dismissIndexTitle()
            }
            
            
            })
        
        return indexTitleIndexArray[index]
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func showIndexTitle(indexTitle: String){
        
        self.dismissBtn.enabled = false
        self.view.userInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        self.view.addSubview(indexTitleLabel)
        
    }
    
    func dismissIndexTitle(){
        self.dismissBtn.enabled = true
        self.view.userInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }
    
    
    /** 选中城市处理 */
    func citySelected(cityModel: SCSCityModel){
        
        if let cityIndex = self.selectedCityArray.indexOf(cityModel.name) {
            self.selectedCityArray.removeAtIndex(cityIndex)
            
        }else{
            if self.selectedCityArray.count >= 8 {self.selectedCityArray.removeLast()}
        }
        
        self.selectedCityArray.insert(cityModel.name, atIndex: 0)
        
        NSUserDefaults.standardUserDefaults().setObject(self.selectedCityArray, forKey: SelectedCityKey)
        
        selectedCityModel?(cityModel: cityModel)
        
        delegate?.selectedCityModel(self, cityModel: cityModel)
        self.dismiss()
    }
    
    

    /** 处理索引 */
    func indexHandle() -> [String] {
        
        var indexArr: [String] = []
        
        for (index,cityModel) in sortedCityModles.enumerate() {
            let indexString = cityModel.getFirstUpperLetter
            
            if indexArr.contains(indexString) {continue}
            
            indexArr.append(indexString)
            
            indexTitleIndexArray.append(index)
        }
        
        return indexArr
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        indexTitleLabel.center = self.view.center
    }


}

