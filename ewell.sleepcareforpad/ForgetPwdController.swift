//
//  ForgetPwdController.swift
//  
//
//  Created by Qinyuan Liu on 6/24/16.
//
//

import UIKit

class ForgetPwdController: IBaseViewController ,SendVerifyTimer2Delegate{
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtVerify: UITextField!
    @IBOutlet weak var btnSendVerify: UIButton!
    @IBOutlet weak var btnSecurePwd: UIButton!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    var forgetpwdViewModel:ForgetPwdViewModel!
    
    //默认情况下密码输入不可见，选中，则可见。
    @IBAction func ClickSecurePwd(sender:UIButton){
        self.btnSecurePwd.selected = !self.btnSecurePwd.selected
        if btnSecurePwd.selected{
            self.txtPass.secureTextEntry = false
            self.txtConfirmPass.secureTextEntry = false
        }
        else{
            self.txtPass.secureTextEntry = true
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
        self.forgetpwdViewModel = ForgetPwdViewModel()
        self.forgetpwdViewModel.parentController = self
        self.forgetpwdViewModel.sendVerifyTimerDelegate = self
        
        
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码不可见.png"), forState: UIControlState.Normal)
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码可见.png"), forState: UIControlState.Selected)
 
        self.txtPhone.rac_textSignal() ~> RAC(self.forgetpwdViewModel, "Phone")
        self.txtVerify.rac_textSignal() ~> RAC(self.forgetpwdViewModel, "VerifyNumber")
        self.txtPass.rac_textSignal() ~> RAC(self.forgetpwdViewModel, "Pwd")
        self.txtConfirmPass.rac_textSignal() ~> RAC(self.forgetpwdViewModel, "ConfirmPwd")
        

        self.btnSendVerify!.rac_command = self.forgetpwdViewModel?.SendVerifyCommand
        self.btnConfirm!.rac_command = self.forgetpwdViewModel?.ConfirmCommand
    }

    //60s倒计时定时器
    var realtimer:NSTimer!
    var seconds:Int = 60
    
    func SendVerifyTimer2(){
        seconds = 60
        self.btnSendVerify.userInteractionEnabled = false
        self.lblTimer.hidden = false
        realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "SpnnerTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
        
        
    }
    func SpnnerTimerFireMethod(timer: NSTimer) {
        seconds -= 1
        self.lblTimer.text = String(seconds)
        
        if seconds == 0{
            realtimer.invalidate()
            self.lblTimer.hidden = true
            self.btnSendVerify.userInteractionEnabled = true
            self.btnSendVerify.selected = false
        }
    }

   

}
