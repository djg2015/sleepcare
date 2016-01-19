    //
    //  IMySelfConfigurationController.swift
    //  ewell.sleepcareforpad
    //
    //  Created by zhaoyin on 15/11/12.
    //  Copyright (c) 2015年 djg. All rights reserved.
    //
    
    import Foundation
    import UIKit
    
    class IMySelfConfiguration: UIView,SetAlarmPicDelegate{
        
        @IBOutlet weak var menuTableView: ConfiurationTabeView!
        
        @IBOutlet weak var imgHeadFace: UIImageView!
        
        @IBOutlet weak var lblManType: UILabel!
        
        var parentController:IBaseViewController!
        
        var menuAlarm:ConfigurationViewModel!
        // 界面初始化
        func viewInit(parentController:IBaseViewController?,bedUserCode:String?,equipmentID:String?)
        {
            self.parentController = parentController
            var source = Array<ConfigurationViewModel>()
            var menu:ConfigurationViewModel = ConfigurationViewModel()
            IAlarmHelper.GetAlarmInstance().alarmpicdelegate = self
            
            // 根据用户类型(监护人/使用者)设置对应的菜单 1.使用者 2.监护人
            if(SessionForIphone.GetSession()!.User?.UserType == LoginUserType.Monitor)
            {
                menu = ConfigurationViewModel()
                menu.imageName = "myElder"
                menu.titleName = "我的老人"
                menu.configrationController = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                source.append(menu)
                
                self.menuAlarm = ConfigurationViewModel()
                self.menuAlarm.imageName = "none_alarm"
                self.menuAlarm.titleName = "报警信息"
                self.menuAlarm.configrationController = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
                source.append(self.menuAlarm)
                
                menu = ConfigurationViewModel()
                menu.imageName = "rankingListMenu"
                menu.titleName = "排行榜"
                source.append(menu)
                
                menu = ConfigurationViewModel()
                menu.imageName = "settingMenu"
                menu.titleName = "设置"
                menu.configrationController = IMySelfSettingController(nibName:"IMySelfSettingView", bundle:nil)
                source.append(menu)
                self.imgHeadFace.image = UIImage(named: "manHeadFace")
                self.lblManType.text = "监护人"
            }
            else if(SessionForIphone.GetSession()!.User?.UserType == LoginUserType.UserSelf)
            {
                menu = ConfigurationViewModel()
                menu.imageName = "myElder"
                menu.titleName = "我的老人"
                menu.configrationController = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                source.append(menu)
                
                self.menuAlarm = ConfigurationViewModel()
                self.menuAlarm.imageName = "none_alarm"
                self.menuAlarm.titleName = "报警信息"
                self.menuAlarm.configrationController = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
                source.append(menuAlarm)
                
                if(nil != equipmentID)
                {
                    menu = ConfigurationViewModel()
                    menu.imageName = "myRequipment"
                    menu.titleName = "我的设备"
                    menu.configrationController = IEquipmentViewController(nibName:"IEquipmentView", bundle:nil,equipmentID:equipmentID!)
                    source.append(menu)
                }
                
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
                menu.configrationController = IMySelfSettingController(nibName:"IMySelfSettingView", bundle:nil)
                source.append(menu)
                imgHeadFace.image = UIImage(named: "manHeadFace")
                self.lblManType.text = "使用者"
            }
            else
            {
                showDialogMsg(ShowMessage(MessageEnum.ChooseUsertypeReminder), title: "提示")
            }
            
            self.menuTableView.parentController = self.parentController
            self.menuTableView.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
            self.menuTableView.tableViewDataSource = source
            self.menuTableView.reloadData()
        }
        
        //设置报警信息图标。当前有alarm，则设置为红色；否则，为蓝色
        func SetAlarmPic(count:Int) {
            if count > 0 {
                if self.menuAlarm.imageName == "none_alarm"{
                    self.menuAlarm.imageName = "alarm"
                    self.menuTableView.reloadData()
                }
            }
            else{
                if self.menuAlarm.imageName == "alarm"{
                    self.menuAlarm.imageName = "none_alarm"
                    self.menuTableView.reloadData()
                }
            }
        }
    }