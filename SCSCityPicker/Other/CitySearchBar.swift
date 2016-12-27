//
//  SCSCitySearchBar.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/15.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class CitySearchBar: UISearchBar,UISearchBarDelegate {
    
    var searchBarShouldBeginEditing: (()->())?
    var searchBarDidEndditing: (()->())?
    
    var searchAction: ((_ searchText: String)->Void)?
    var searchTextDidChangedAction: ((_ searchText: String)->Void)?
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
        
        self.backgroundColor = UIColor.clear
        self.backgroundImage = UIImage()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.placeholder = "输入城市名、拼音或者首字母查询"
        self.tintColor = UIColor.gray
        
        self.delegate = self
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarShouldBeginEditing?()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBarDidEndditing?()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBarCancelAction?()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAction?(searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTextDidChangedAction?(searchText)
    }


    

}
