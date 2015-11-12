//
//  IMySelfSettingController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class IMySelfSettingController: IBaseViewController {
    
    @IBOutlet weak var menuTableView: ConfiurationTabeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var source = Array<ConfigurationViewModel>()
        var menu:ConfigurationViewModel = ConfigurationViewModel()
        
        menu = ConfigurationViewModel()
        menu.titleName = "账号管理"
        source.append(menu)
        
        menu = ConfigurationViewModel()
        menu.titleName = "意见反馈"
        source.append(menu)
        
        menu = ConfigurationViewModel()
        menu.titleName = "使用技巧"
        source.append(menu)
        
        menu = ConfigurationViewModel()
        menu.titleName = "软件版本"
        source.append(menu)
        
        menu = ConfigurationViewModel()
        menu.titleName = "关于uSleepCare"
        source.append(menu)
        
        self.menuTableView.showMenuImage = false
        self.menuTableView.backgroundColor = UIColor.whiteColor()
        self.menuTableView.tableViewDataSource = source
        self.menuTableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}