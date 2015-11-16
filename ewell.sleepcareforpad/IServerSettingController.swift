//
//  IServerSettingController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

import UIKit

class IServerSettingController:BaseViewController {
    
    @IBOutlet weak var txtServerJid: UITextField!
    
    @IBOutlet weak var txtServerAddress: UITextField!
    
    @IBOutlet weak var txtServerPort: UITextField!
    
    @IBOutlet weak var txtServerLoginName: UITextField!
    
    @IBOutlet weak var txtServerPwd: UITextField!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    //-----------界面事件定义----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtServerJid.text = GetValueFromPlist("serverjid")
        self.txtServerAddress.text = GetValueFromPlist("xmppserver")
        self.txtServerPort.text = GetValueFromPlist("xmppport")
        self.txtServerLoginName.text = GetValueFromPlist("xmppusername")
        self.txtServerPwd.text = GetValueFromPlist("xmppuserpwd")
        
        self.imgBack.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgBack .addGestureRecognizer(singleTap)
        
        
    }
    
    func imageViewTouch(){
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
                
                showDialogMsg("服务端配置保存成功", "提示", buttonTitle: "确定", action: { (isOtherButton) -> Void in
                    self.clickOK(nil)
                })  
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
    
    func clickOK(action:UIAlertAction!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
