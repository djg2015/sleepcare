//
//  IRegistViewController.swift
//
//
//  Created by djg on 15/11/12.
//
//

import UIKit

class IRegistViewController: IBaseViewController,PopDownListItemChoosed {
    @IBOutlet weak var txtLoginName: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtRePwd: UITextField!
    @IBOutlet weak var txtMain: UITextField!
    
    @IBOutlet weak var btnBack: BlueButtonForPhone!
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    @IBOutlet weak var btnChooseRole: UIButton!
    var popDownListForIphone:PopDownListForIphone?
    var iRegistViewModel:IRegistViewModel!
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
        self.iRegistViewModel = IRegistViewModel()
      //  self.iRegistViewModel.controllerForIphone = self
        self.btnRegist!.rac_command = self.iRegistViewModel?.registCommand
        self.txtLoginName.rac_textSignal() ~> RAC(self.iRegistViewModel, "LoginName")
        self.txtPwd.rac_textSignal() ~> RAC(self.iRegistViewModel, "Pwd")
        self.txtRePwd.rac_textSignal() ~> RAC(self.iRegistViewModel, "RePwd")
        
        self.btnBack!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                IViewControllerManager.GetInstance()!.CloseViewController()
                //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.btnChooseRole!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(self.popDownListForIphone == nil){
                    
                    self.popDownListForIphone = PopDownListForIphone()
                    self.popDownListForIphone?.delegate = self
                }
                self.popDownListForIphone?.Show("选择养老院/医院", source:self.iRegistViewModel!.MainBusinesses)
        }
    }
    
    func ChoosedItem(item:PopDownListItem){
        self.iRegistViewModel.MainCode = item.key!
        self.txtMain.text = item.value
    }
    
    
    
}
