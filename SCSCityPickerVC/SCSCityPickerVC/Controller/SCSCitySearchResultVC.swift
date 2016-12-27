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
    var tableViewDidSelectedRowAction: ((_ cityModel: SCSCityModel)->())!
    
    
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cityModels == nil {return 0}
        
        print(cityModels.count)
        
        return cityModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SCSCityCell.cityCellInTableView(tableView)
        
        cell.cityModel = cityModels[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableViewDidSelectedRowAction?(cityModels[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.cityModels == nil {return nil}
        return "共检索到\(self.cityModels.count)到记录"
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchBeganAction?()
    }
    
    func dataPrepare(){
        
        self.tableView.isHidden = self.cityModels == nil
        
        
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewScrollAction?()
    }


}
