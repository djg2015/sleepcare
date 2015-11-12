//
//  IMySelfConfigurationController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class IMySelfConfiguration: UIView{
    
    @IBOutlet weak var menuTableView: ConfiurationTabeView!
    
    var parentController:IBaseViewController!
    
    // 界面初始化
    func viewInit(parentController:IBaseViewController?)
    {
        self.parentController = parentController
        var source = Array<ConfigurationViewModel>()
        var menu:ConfigurationViewModel = ConfigurationViewModel()
        // 根据用户类型(监护人/使用者)设置对应的菜单
        if(true)
        {
            menu = ConfigurationViewModel()
            menu.imageName = "myElder"
            menu.titleName = "我的老人"
            source.append(menu)
            
            menu = ConfigurationViewModel()
            menu.imageName = "rankingListMenu"
            menu.titleName = "排行榜"
            source.append(menu)
            
            menu = ConfigurationViewModel()
            menu.imageName = "settingMenu"
            menu.titleName = "设置"
            menu.configrationController = IMySelfSettingController(nibName:"IMySelfSettingView", bundle:nil)
            source.append(menu)
        }
        else
        {
            menu = ConfigurationViewModel()
            menu.imageName = "myRequipment"
            menu.titleName = "我的设备"
            source.append(menu)
            
            menu = ConfigurationViewModel()
            menu.imageName = "trendMenu"
            menu.titleName = "趋势"
            source.append(menu)
            
            menu = ConfigurationViewModel()
            menu.imageName = "rankingListMenu"
            menu.titleName = "排行榜"
            source.append(menu)
            
            menu = ConfigurationViewModel()
            menu.imageName = "settingMenu"
            menu.titleName = "设置"
            source.append(menu)
        }

        self.menuTableView.parentController = self.parentController
        self.menuTableView.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        self.menuTableView.tableViewDataSource = source
        self.menuTableView.reloadData()
    }
    
    
}