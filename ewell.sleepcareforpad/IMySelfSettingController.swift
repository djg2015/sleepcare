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
    
    @IBOutlet weak var imgBack: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var source = Array<ConfigurationViewModel>()
        var menu:ConfigurationViewModel = ConfigurationViewModel()
        
        menu = ConfigurationViewModel()
        menu.titleName = "账号管理"
        menu.configrationController = IAccountSetController(nibName:"IAccountSet", bundle:nil)
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
        self.menuTableView.parentController = self
        self.menuTableView.backgroundColor = UIColor.whiteColor()
        self.menuTableView.tableViewDataSource = source
        self.menuTableView.reloadData()
        
        self.imgBack.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToController:")
        self.imgBack.addGestureRecognizer(singleTap)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnExitLoginClick(sender: AnyObject) {
        SessionForIphone.ClearSession()
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        xmppMsgManager?.Close()
        self.presentViewController(ILoginController(nibName:"ILogin", bundle:nil), animated: true, completion: nil)
    }
    
    func backToController(sender:UITapGestureRecognizer)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}