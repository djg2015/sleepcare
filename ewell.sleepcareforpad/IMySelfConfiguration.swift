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
        
        @IBOutlet weak var topView: UIView!
        @IBOutlet weak var menuTableView: ConfiurationTabeView!
        @IBOutlet weak var lblManType: UILabel!
        @IBOutlet weak var BtnExit: UIButton!
        
        var parentController:IBaseViewController!
        var menuAlarm:ConfigurationViewModel?
        var menu:ConfigurationViewModel?
        var session = SessionForIphone.GetSession()
        var source:Array<ConfigurationViewModel> = []
        // 界面初始化
        func viewInit(parentController:IBaseViewController?,bedUserCode:String?,equipmentID:String?)
        {
            self.topView.backgroundColor = themeColor[themeName]
            self.parentController = parentController
            self.source = Array<ConfigurationViewModel>()
            IAlarmHelper.GetAlarmInstance().alarmpicdelegate = self
            self.BtnExit.backgroundColor = themeColor[themeName]
            
            // 根据用户类型(监护人/使用者)设置对应的菜单 1.使用者 2.监护人
            if(self.session != nil && session!.User?.UserType == LoginUserType.Monitor)
            {
                menu = ConfigurationViewModel()
                menu!.titleName = "我的老人"
                menu!.configrationController = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                source.append(menu!)
                
                self.menuAlarm = ConfigurationViewModel()
                self.menuAlarm!.titleName = "报警信息"
                self.menuAlarm!.imageName = "noalarm.png"
                self.menuAlarm!.configrationController = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
                source.append(self.menuAlarm!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "账号管理"
                menu!.configrationController =
                    IAccountSetController(nibName:"IAccountSet", bundle:nil)
                source.append(menu!)
            
                menu = ConfigurationViewModel()
                menu!.titleName = "使用技巧"
                menu!.configrationController = IWebViewController(nibName:"WebView",bundle:nil,titleName:"使用技巧",url:"http://www.usleepcare.com/app/help.aspx")
                source.append(menu!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "关于uSleepCare"
                menu!.configrationController = IWebViewController(nibName:"WebView",bundle:nil,titleName:"关于uSleepCare",url:"http://www.usleepcare.com/app/about.aspx")
                source.append(menu!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "软件版本"
                source.append(menu!)
                
                self.lblManType.text = "监护人"
            }
            else if(self.session != nil && session!.User?.UserType == LoginUserType.UserSelf)
            {
                menu = ConfigurationViewModel()
                menu!.titleName = "我的老人"
                menu!.configrationController = IMyPatientsController(nibName:"IMyPatients", bundle:nil)
                source.append(menu!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "账号管理"
                menu!.configrationController =  IAccountSetController(nibName:"IAccountSet", bundle:nil)
                source.append(menu!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "使用技巧"
                menu!.configrationController = IWebViewController(nibName:"WebView",bundle:nil,titleName:"使用技巧",url:"http://www.usleepcare.com/app/help.aspx")
                source.append(menu!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "关于uSleepCare"
                menu!.configrationController = IWebViewController(nibName:"WebView",bundle:nil,titleName:"关于uSleepCare",url:"http://www.usleepcare.com/app/about.aspx")
                source.append(menu!)
                
                menu = ConfigurationViewModel()
                menu!.titleName = "软件版本"
                source.append(menu!)
                
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
            if self.menuAlarm != nil{
                if count > 0 {
                    if self.menuAlarm!.imageName == "noalarm.png"{
                        self.menuAlarm!.imageName = "alarm.png"
                        self.menuTableView.reloadData()
                    }
                }
                else{
                    if self.menuAlarm!.imageName == "alarm.png"{
                        self.menuAlarm!.imageName = "noalarm.png"
                        self.menuTableView.reloadData()
                    }
                }
            }
        }
        
        
        func Clean(){
            self.source = []
            self.menu = nil
            self.menuAlarm = nil
            self.topView = nil
            self.menuTableView = nil
        }
        
        //退出登录：清空本地plist文件内账户信息，清空当前session，如果是监护人账户则关闭报警，关闭xmpp。最后跳转登录页面
        @IBAction func btnExitLoginClick(sender: AnyObject) {
           CloseNotice()
            
            SetValueIntoPlist("loginusernamephone", "")
            SetValueIntoPlist("loginuserpwdphone", "")
            SetValueIntoPlist("xmppusernamephone", "")
            LOGINFLAG = false
           
            let session = SessionForIphone.GetSession()
            //关闭alarm，清除session
            if session != nil && session!.User!.UserType == LoginUserType.Monitor {
                IAlarmHelper.GetAlarmInstance().CloseWaringAttention()
    
            }
                     
            
            //关闭xmpp
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            xmppMsgManager?.Close()
            
            //重新打开登陆页面
            let logincontroller = ILoginController(nibName:"ILogin", bundle:nil)
            IViewControllerManager.GetInstance()!.ShowViewController(logincontroller, nibName: "ILogin", reload: true)
        }
    }