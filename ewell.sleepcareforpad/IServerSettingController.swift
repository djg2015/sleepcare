//
//  IServerSettingController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

import UIKit

class IServerSettingController:IBaseViewController {
    
    @IBOutlet weak var txtServerJid: UITextField!
    
    @IBOutlet weak var txtServerAddress: UITextField!
    
    @IBOutlet weak var txtServerPort: UITextField!
    
    @IBOutlet weak var txtServerLoginName: UITextField!
    
    @IBOutlet weak var txtServerPwd: UITextField!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    
    //-----------界面事件定义----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.backgroundColor = themeColor[themeName]
        
        self.txtServerJid.text = GetValueFromPlist("serverjid","sleepcare.plist")
        self.txtServerAddress.text = GetValueFromPlist("xmppserver","sleepcare.plist")
        self.txtServerPort.text = GetValueFromPlist("xmppport","sleepcare.plist")
        self.txtServerLoginName.text = GetValueFromPlist("xmppusernamephone","sleepcare.plist")
        self.txtServerPwd.text = GetValueFromPlist("xmppuserpwd","sleepcare.plist")
        
        self.imgBack.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgBack .addGestureRecognizer(singleTap)
        
        
    }
    
    func imageViewTouch(){
      IViewControllerManager.GetInstance()!.CloseViewController()
    }
    
    //保存服务器信息，写入本地plist文件，弹窗提示操作成功
    @IBAction func btnSave(sender: AnyObject) {
        try {
            ({
                SetValueIntoPlist("serverjid",self.txtServerJid.text)
                SetValueIntoPlist("xmppserver",self.txtServerAddress.text)
                SetValueIntoPlist("xmppport",self.txtServerPort.text)
                SetValueIntoPlist("xmppusernamephone",self.txtServerLoginName.text)
                SetValueIntoPlist("xmppuserpwd",self.txtServerPwd.text)
                
                showDialogMsg(ShowMessage(MessageEnum.ServerSettingSuccess), "提示", buttonTitle: "确定", action: { (isOtherButton) -> Void in
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
    
    //点击确认后关闭当前页面
    func clickOK(action:UIAlertAction!)
    {
      IViewControllerManager.GetInstance()!.CloseViewController()
    }
    
}
