//
//  SCSCitySearchBar.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/15.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class SCSCitySearchBar: UISearchBar,UISearchBarDelegate {
    
    var searchBarShouldBeginEditing: (()->())?
    var searchBarDidEndditing: (()->())?
    
    var searchAction: ((searchText: String)->Void)?
    var searchTextDidChangedAction: ((searchText: String)->Void)?
    var searchBarCancelAction: (()->())?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.viewPrepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.viewPrepare()
    }
    
    /// 准备视图
    func viewPrepare(){
        
        self.backgroundColor = UIColor.clearColor()
        self.backgroundImage = UIImage()
        self.layer.borderColor = SCSCityPickerVC.cityPVCTintColor.CGColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
//        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = "输入城市名、拼音或者首字母查询"
        self.tintColor = SCSCityPickerVC.cityPVCTintColor
        
        self.delegate = self
    }
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarShouldBeginEditing?()
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBarDidEndditing?()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBarCancelAction?()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchAction?(searchText: searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTextDidChangedAction?(searchText: searchText)
    }


    

}
