//
//  RootRegistViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/6/16.
//
//

import UIKit

class RootRegistViewController: IBaseViewController,SendVerifyTimerDelegate {
    
    
    @IBOutlet weak var btnRegist: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtVerify: UITextField!
    @IBOutlet weak var btnSendVerify: UIButton!
    @IBOutlet weak var btnSecurePwd: UIButton!
    @IBOutlet weak var btnScan: UIButton!
     @IBOutlet weak var btnAgreeProtocol: UIButton!
     @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var QRcodeLabel: UILabel!
    @IBOutlet weak var ScanImage: UIImageView!
    
    @IBOutlet weak var lblTimer: UILabel!

    
    var registViewModel:IRegistViewModel!
    
    
    var qrcode:String?{
        didSet{
            //验证二维码，成功：显示在页面上并赋值给model；失败：错误弹窗
            if self.registViewModel.VerifyQR(qrcode!){
                self.QRcodeLabel.text = "设备编码： " + qrcode!
                self.registViewModel.QRCode = qrcode!
                self.QRcodeLabel.hidden = false
                self.btnScan.hidden = true
                self.ScanImage.hidden = true

            }
        }
    }
 
    @IBAction func UnwindShowProtocol(unwindsegue:UIStoryboardSegue){
  
    }
    
    @IBAction func UnwindScan(unwindsegue:UIStoryboardSegue){
        
    }
    
  
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //点击扫一扫按钮,跳转“扫描二维码”页面
        if segue.identifier == "registscan" {
            let destinationVC = segue.destinationViewController as! ScanViewController
            destinationVC.registController = self
            
        }
        //注册成功后，跳转“老人信息”页面
        else if segue.identifier == "patientinfo" {
            let destinationVC = segue.destinationViewController as! EquipmentViewController
            destinationVC.qrcode = self.qrcode!
            destinationVC.registcontroller = self
         
            
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
        self.registViewModel = IRegistViewModel()
        self.registViewModel.parentController = self
        self.registViewModel.sendVerifyTimerDelegate = self
        
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码不可见.png"), forState: UIControlState.Normal)
         self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码可见.png"), forState: UIControlState.Selected)
         self.btnAgreeProtocol.setBackgroundImage(UIImage(named: "icon_checkno.png"), forState: UIControlState.Normal)
        self.btnAgreeProtocol.setBackgroundImage(UIImage(named: "icon_checkyes.png"), forState: UIControlState.Selected)
        self.btnSendVerify.setBackgroundImage(UIImage(named: "icon_60s.png"), forState: UIControlState.Selected)
        self.btnSendVerify.setBackgroundImage(UIImage(named: "icon_获取验证码.png"), forState: UIControlState.Normal)
        
        
        self.txtPhone.rac_textSignal() ~> RAC(self.registViewModel, "Phone")
        self.txtVerify.rac_textSignal() ~> RAC(self.registViewModel, "VerifyNumber")
        self.txtPass.rac_textSignal() ~> RAC(self.registViewModel, "Pwd")
         self.txtConfirmPass.rac_textSignal() ~> RAC(self.registViewModel, "ConfirmPwd")
        RACObserve(self.registViewModel, "IsChecked") ~> RAC(self.btnAgreeProtocol, "selected")
       RACObserve(self.registViewModel, "ClickSendVerify") ~> RAC(self.btnSendVerify, "selected")
        
        
        self.btnSendVerify!.rac_command = self.registViewModel?.SendVerifyCommand
         self.btnAgreeProtocol.rac_command = self.registViewModel?.AgreeProtocolCommand
         self.btnRegist!.rac_command = self.registViewModel?.RegistCommand
    }
    

    
    //60s倒计时定时器
    var realtimer:NSTimer!
    var seconds:Int = 60

    func SendVerifyTimer(){
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
