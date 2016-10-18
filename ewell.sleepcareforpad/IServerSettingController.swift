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
    

    override func viewWillAppear(animated: Bool) {
  
   
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.topView.backgroundColor = themeColor[themeName]
        
        self.txtServerJid.text = PLISTHELPER.ServerJID
        self.txtServerAddress.text = PLISTHELPER.XmppServer
        self.txtServerPort.text = PLISTHELPER.XmppPort
        self.txtServerLoginName.text = PLISTHELPER.XmppUsername
        self.txtServerPwd.text = PLISTHELPER.XmppUserpwd
        
        
    }
   

    
    //保存服务器信息，写入本地plist文件，弹窗提示操作成功
    @IBAction func btnSave(sender: AnyObject) {
        try {
            ({
               PLISTHELPER.ServerJID = self.txtServerJid.text
              PLISTHELPER.XmppServer = self.txtServerAddress.text
              PLISTHELPER.XmppPort  = self.txtServerPort.text
              PLISTHELPER.XmppUsername  = self.txtServerLoginName.text
              PLISTHELPER.XmppUserpwd = self.txtServerPwd.text
                
                showDialogMsg(ShowMessage(MessageEnum.ServerSettingSuccess), "提示", buttonTitle: "确定", action: nil)
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
    }
    
    
}
