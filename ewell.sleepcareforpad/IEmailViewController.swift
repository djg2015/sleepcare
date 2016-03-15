//
//  IEmailViewController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class IEmailViewController: IBaseViewController {
    

    @IBOutlet weak var txtEmailAddress: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var btnSendEmail: BlueButtonForPhone!
    
    var emailViewModel:IEmailViewModel?
    
    var BedUserCode:String = ""
    var SleepDate:String = ""
    var ParentController:IBaseViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        self.emailViewModel = IEmailViewModel()
        self.emailView.backgroundColor = themeColor[themeName]
        self.rac_settings()
    }
    
    override func Clean(){
        self.emailView = nil
        self.emailViewModel = nil
    }
    
    
    func rac_settings(){
        // 绑定界面元素
        RACObserve(self, "BedUserCode") ~> RAC(self.emailViewModel, "BedUserCode")
        RACObserve(self, "SleepDate") ~> RAC(self.emailViewModel, "SleepDate")
        RACObserve(self, "ParentController") ~> RAC(self.emailViewModel, "ParentController")
        
        self.txtEmailAddress.rac_textSignal() ~> RAC(self.emailViewModel, "EmailAddress")
        self.btnSendEmail.rac_command = self.emailViewModel!.sendEmailCommand
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
         self.ParentController.dismissSemiModalView()
    }
}
