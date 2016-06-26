//
//  RootLoginViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/2/16.
//
//

import UIKit

class RootLoginViewController: IBaseViewController,LoginButtonDelegate{
   
    @IBOutlet weak var telephoneText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var rememberPwdBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    

   var iloginViewModel:IloginViewModel!
    
    
  
    @IBAction func UnwindRegist(unwindsegue:UIStoryboardSegue){
        
   
    }
    @IBAction func UnwindForgetPwd(unwindsegue:UIStoryboardSegue){
        
        
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
      self.iloginViewModel = IloginViewModel()
         self.iloginViewModel.controller = self
        self.iloginViewModel.loginbuttonDelegate = self
        
        
        self.rememberPwdBtn.setBackgroundImage(UIImage(named: "icon_norememberpwd.png"), forState: UIControlState.Normal)
        self.rememberPwdBtn.setBackgroundImage(UIImage(named: "icon_rememberpwd.png"), forState: UIControlState.Selected)
        self.rememberPwdBtn.selected = true
        
        //初始化页面数据
         self.iloginViewModel.LoadData()
        
         self.loginBtn.rac_command = self.iloginViewModel?.loginCommand
        self.rememberPwdBtn.rac_command = self.iloginViewModel?.rememberCommand
        
        RACObserve(self.iloginViewModel, "Telephone") ~> RAC(self.telephoneText, "text")
        RACObserve(self.iloginViewModel, "Pwd") ~> RAC(self.passwordText, "text")
        self.telephoneText.rac_textSignal() ~> RAC(self.iloginViewModel, "Telephone")
        self.passwordText.rac_textSignal() ~> RAC(self.iloginViewModel, "Pwd")
         RACObserve(self.iloginViewModel, "IsRememberpwd") ~> RAC(self.rememberPwdBtn, "selected")
    }

    func DisableLoginButton() {
        self.loginBtn.userInteractionEnabled = false
    }
    
    func EnableLoginButton() {
        self.loginBtn.userInteractionEnabled = true
    }
    
   

}
