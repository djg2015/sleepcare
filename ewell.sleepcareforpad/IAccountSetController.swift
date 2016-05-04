//
//  IAccountSetController.swift
//
//
//  Created by djg on 15/11/23.
//
//

import UIKit

class IAccountSetController: IBaseViewController, PopDownListItemChoosed{
    
    @IBOutlet weak var txtMain: UITextField!
    @IBOutlet weak var txtRePwd: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var btnSave: BlueButtonForPhone!
    @IBOutlet weak var btnBack: BlueButtonForPhone!
    @IBOutlet weak var btnChooseRole: UIButton!
    
    var popDownListForIphone:PopDownListForIphone?
    var iModifyViewModel:IModifyViewModel!
    var parentController:MyConfigueTableViewController!
    
    @IBAction func ClickCancle(sender:AnyObject){
    self.dismissViewControllerAnimated(false, completion: nil)
        currentController = parentController
        self.parentController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = themeColor[themeName]
        rac_settings()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    
        currentController = self
    }

    //-------------自定义方法处理---------------
    func rac_settings(){
        self.iModifyViewModel = IModifyViewModel()
        self.iModifyViewModel.controller = self
        self.btnSave!.rac_command = self.iModifyViewModel?.modifyCommand
        RACObserve(self.iModifyViewModel, "LoginName") ~> RAC(self.txtLoginName, "text")
        RACObserve(self.iModifyViewModel, "Pwd") ~> RAC(self.txtPwd, "text")
        RACObserve(self.iModifyViewModel, "RePwd") ~> RAC(self.txtRePwd, "text")
        RACObserve(self.iModifyViewModel, "MainName") ~> RAC(self.txtMain, "text")
        
      
        self.txtPwd.rac_textSignal() ~> RAC(self.iModifyViewModel, "Pwd")
        self.txtRePwd.rac_textSignal() ~> RAC(self.iModifyViewModel, "RePwd")
        
        
       
        
        self.btnChooseRole!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(self.popDownListForIphone == nil){
                    self.popDownListForIphone = PopDownListForIphone()
                    self.popDownListForIphone?.delegate = self
                }
                self.popDownListForIphone?.Show("选择养老院/医院", source:self.iModifyViewModel!.MainBusinesses)
        }
    }
    
    func ChoosedItem(item:PopDownListItem){
        self.iModifyViewModel.MainCode = item.key!
        self.iModifyViewModel.MainName = item.value!
        self.txtMain.text = item.value
    }
    
}
