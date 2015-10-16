//
//  SCSCityPickerVC.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/15.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

/** 通知 */
let CityChoosedNoti = "CityChoosedNoti"

/** 归档key */
let SelectedCityKey = "SelectedCityKey"

protocol SCSCityPickerVCDelegate : NSObjectProtocol {
    
    func selectedCityModel(cityPicker: SCSCityPickerVC, cityModel:SCSCityModel)
}

class SCSCityPickerVC: UIViewController {
    
    static let cityPVCTintColor = UIColor.grayColor()
    
    weak var delegate: SCSCityPickerVCDelegate!
    /// 默认城市模型
    var cityModels: [SCSCityModel]?
    /// 国内城市模型
    var chinaCityModels:[SCSCityModel]!
    /// 国外城市模型
    var foreignCityModels: [SCSCityModel]!
    /// 搜索栏
    var searchBar: SCSCitySearchBar!
    /// 搜索结果的控制器
    var searchRVC: SCSCitySearchResultVC!
    
    lazy var tableView = UITableView()
    
    var currentCityItemView: SCSHeaderItemView!
    
    lazy var indexTitleLabel = UILabel()
    
    var showTime: CGFloat = 1.0
    
    var indexTitleIndexArray: [Int] = []
    
    var selectedCityModel :((cityModel: SCSCityModel) -> Void)?
    
    /// 关闭按钮
    lazy var dismissBtn: UIButton = { UIButton(frame: CGRectMake(0, 0, 24, 24)) }()
    /// 可以设置当前城市
    var currentCity: String! {
        didSet {
            getedCurrentCityWithName(currentCity)
        }
    }
    
    /// 设置热门城市
    var hotCities: [String]!
    /// 是否是push的方式显示的,是的话则不显示关闭按钮
    var isPush:Bool = false
    /// 是否显示搜索框
    var showSearchBar = true
    /// 是否需要启用定位服务,默认开启
    var showLocation = true
    /// 是否显示热门城市
    var showHotCity = true
    /// 是否显示历史选择城市
    var showHistoryCity = true
    /// 是否需要显示国外城市
    var showForeignCity = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if cityModels == nil {
            
            let cityModels = SCSCityModel.cityModelsPrepare()
            self.cityModels = cityModels
            
            self.chinaCityModels = cityModels
            self.foreignCityModels = SCSCityModel.foreignCityModelsPrepare()
            
            hotCities = ["北京","上海","广州","成都","杭州","重庆"]
            
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //根据是否是push的展示来决定是否加载关闭按钮
        isPush ? () : dismissBtnPrepare()
        
        // 为tableView准备
        tableViewPrepare()
        
        // 处理label
        labelPrepare()
        
        self.tableView.sectionIndexColor = SCSCityPickerVC.cityPVCTintColor
        
        // headerView
        headerviewPrepare()
        
        // 定位处理
        showLocation ? locationPrepare() : ()
        
        showForeignCity ? self.navigationItem.titleView = navSegment : ()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //通知处理
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notiAction:", name: CityChoosedNoti, object: nil)
        
        
    }
    
  
    
    /// 准备关闭按钮
    func dismissBtnPrepare(){
        
        dismissBtn.setImage(UIImage(named: "Resource.bundle/cancel"), forState: UIControlState.Normal)
        dismissBtn.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissBtn)
    }
    
    /// 关闭控制器
    func dismiss(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 选择国内外数据
    func selectCountry() {
        
        if navSegment.selectedSegmentIndex == 0 {
            self.cityModels = chinaCityModels
            self.tableView.reloadData()
        } else if navSegment.selectedSegmentIndex == 1 {
            self.cityModels = foreignCityModels
            self.tableView.reloadData()
        }
        
    }

    lazy var navSegment:UISegmentedControl = {
        let navSegment = UISegmentedControl(items: ["国内","国外"])
        
        navSegment.selectedSegmentIndex = 0
        
        navSegment.addTarget(self, action: "selectCountry", forControlEvents: UIControlEvents.ValueChanged)
        
        return navSegment
        }()
    
    lazy var selectedCityArray: [String] = {
        NSUserDefaults.standardUserDefaults().objectForKey(SelectedCityKey) as? [String] ?? []
        
        }()
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor{
        
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("控制器安全释放")
    }
    
    
    
    


    

    
}
