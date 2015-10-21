//
//  ServerSettingController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class ServerSettingController:BaseViewController {
    
    @IBOutlet weak var txtServerJid: UITextField!
    
    @IBOutlet weak var txtServerAddress: UITextField!
    
    @IBOutlet weak var txtServerPort: UITextField!
    
    @IBOutlet weak var txtServerLoginName: UITextField!
    
    @IBOutlet weak var txtServerPwd: UITextField!
    
    //-----------界面事件定义----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtServerJid.text = GetValueFromPlist("serverjid")
        self.txtServerAddress.text = GetValueFromPlist("xmppserver")
        self.txtServerPort.text = GetValueFromPlist("xmppport")
        self.txtServerLoginName.text = GetValueFromPlist("xmppusername")
        self.txtServerPwd.text = GetValueFromPlist("xmppuserpwd")
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        try {
            ({
                SetValueIntoPlist("serverjid",self.txtServerJid.text)
                SetValueIntoPlist("xmppserver",self.txtServerAddress.text)
                SetValueIntoPlist("xmppport",self.txtServerPort.text)
                SetValueIntoPlist("xmppusername",self.txtServerLoginName.text)
                SetValueIntoPlist("xmppuserpwd",self.txtServerPwd.text)
                
                var alert = UIAlertController(title: "提示", message: "服务端配置保存成功", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:self.clickOK))
                self.presentViewController(alert, animated: true, completion: nil)
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            )}
    }
    
    func clickOK(action:UIAlertAction!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}