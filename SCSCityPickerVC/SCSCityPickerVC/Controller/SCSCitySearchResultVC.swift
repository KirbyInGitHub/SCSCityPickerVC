//
//  SCSCitySearchResultVC.swift
//  SCSCityPickerVC
//
//  Created by 张鹏 on 15/10/16.
//  Copyright © 2015年 VSEE. All rights reserved.
//

import UIKit

class SCSCitySearchResultVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var touchBeganAction: (()->())!
    var tableViewScrollAction: (()->())!
    var tableViewDidSelectedRowAction: ((cityModel: SCSCityModel)->())!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var cityModels: [SCSCityModel]!{
        didSet {
            dataPrepare()
//            print(cityModels)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cityModels == nil {return 0}
        
        print(cityModels.count)
        
        return cityModels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = SCSCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = cityModels[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableViewDidSelectedRowAction?(cityModel: cityModels[indexPath.row])
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.cityModels == nil {return nil}
        return "共检索到\(self.cityModels.count)到记录"
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchBeganAction?()
    }
    
    func dataPrepare(){
        
        self.tableView.hidden = self.cityModels == nil
        
        
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        tableViewScrollAction?()
    }


}
