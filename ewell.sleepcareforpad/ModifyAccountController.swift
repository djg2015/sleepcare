//
//  ModifyAccountController.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import UIKit

class ModifyAccountController: IBaseViewController {
 
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
     @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
     @IBOutlet weak var btnSecurePwd: UIButton!
    
    
    var modifyaccountViewModel:ModifyAccountViewModel!
    
    
    //默认情况下密码输入不可见，选中，则可见。
    @IBAction func ClickSecurePwd(sender:UIButton){
        self.btnSecurePwd.selected = !self.btnSecurePwd.selected
        if btnSecurePwd.selected{
            self.txtOldPass.secureTextEntry = false
            self.txtNewPass.secureTextEntry = false
            self.txtConfirmPass.secureTextEntry = false
        }
        else{
             self.txtOldPass.secureTextEntry = true
            self.txtNewPass.secureTextEntry = true
            self.txtConfirmPass.secureTextEntry = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rac_settings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func rac_settings(){
        self.modifyaccountViewModel = ModifyAccountViewModel()
         self.modifyaccountViewModel.parentController = self
        
        
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码不可见.png"), forState: UIControlState.Normal)
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码可见.png"), forState: UIControlState.Selected)

         RACObserve(self.modifyaccountViewModel, "Phone") ~> RAC(self.txtPhone, "text")
        self.txtPhone.rac_textSignal() ~> RAC(self.modifyaccountViewModel, "Phone")
        self.txtOldPass.rac_textSignal() ~> RAC(self.modifyaccountViewModel, "OldPwd")
        self.txtNewPass.rac_textSignal() ~> RAC(self.modifyaccountViewModel, "NewPwd")
        self.txtConfirmPass.rac_textSignal() ~> RAC(self.modifyaccountViewModel, "ConfirmPwd")
         self.btnConfirm!.rac_command = self.modifyaccountViewModel?.ConfirmCommand
    }
}
