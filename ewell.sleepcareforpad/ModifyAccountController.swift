//
//  IAccountSetController.swift
//
//
//  Created by djg on 15/11/23.
//
//

import UIKit

class ModifyAccountController: IBaseViewController{
    
    @IBOutlet weak var txtRePwd: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnSecurePwd: UIButton!

   
    
    var iModifyViewModel:IModifyViewModel!
   
    @IBAction func btnBack(sender:AnyObject){
   self.navigationController?.popViewControllerAnimated(true)
    
          }
    
    //默认情况下密码输入不可见，选中，则可见。
    @IBAction func ClickSecurePwd(sender:UIButton){
        self.btnSecurePwd.selected = !self.btnSecurePwd.selected
        if btnSecurePwd.selected{
            
            self.txtPwd.secureTextEntry = false
            self.txtRePwd.secureTextEntry = false
        }
        else{
           
            self.txtPwd.secureTextEntry = true
            self.txtRePwd.secureTextEntry = true
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        currentController = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        rac_settings()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    //-------------自定义方法处理---------------
    func rac_settings(){
        self.iModifyViewModel = IModifyViewModel()
        self.iModifyViewModel.controller = self
       
        
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码不可见"), forState: UIControlState.Normal)
        self.btnSecurePwd.setBackgroundImage(UIImage(named: "icon_密码可见"), forState: UIControlState.Selected)
        
        
        self.btnSave!.rac_command = self.iModifyViewModel?.modifyCommand
        RACObserve(self.iModifyViewModel, "LoginName") ~> RAC(self.txtLoginName, "text")
        RACObserve(self.iModifyViewModel, "Pwd") ~> RAC(self.txtPwd, "text")
        RACObserve(self.iModifyViewModel, "RePwd") ~> RAC(self.txtRePwd, "text")
      
        
        self.txtPwd.rac_textSignal() ~> RAC(self.iModifyViewModel, "Pwd")
        self.txtRePwd.rac_textSignal() ~> RAC(self.iModifyViewModel, "RePwd")

           }
    
 
    
}
