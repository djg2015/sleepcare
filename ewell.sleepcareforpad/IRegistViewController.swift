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
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var CheckBox: UIImageView!
   
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    @IBOutlet weak var btnChooseRole: UIButton!
    @IBOutlet weak var btnChooseType: UIButton!

    var popDownListForIphone:PopDownListForIphone?
    var TypeListForIphone:PopDownListForIphone?
    
    var iRegistViewModel:IRegistViewModel!
    var checkBoxImageName:String = "default_registUncheck.png"
    
    @IBAction func UnwindCloseProtocol(unwindsegue:UIStoryboardSegue){
        
        
    }
    @IBAction func btnTypeInfo(sender: AnyObject) {
        
        showDialogMsg(ShowMessage(MessageEnum.UserTypeInfo))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeColor[themeName]
        rac_settings()
        // Do any additional setup after loading the view.
    }

  
    
//    override func Clean() {
//        self.iRegistViewModel = nil
//    }

    //-------------自定义方法处理---------------
    func rac_settings(){
        self.iRegistViewModel = IRegistViewModel()
        self.btnRegist!.rac_command = self.iRegistViewModel?.registCommand
        self.txtLoginName.rac_textSignal() ~> RAC(self.iRegistViewModel, "LoginName")
        self.txtPwd.rac_textSignal() ~> RAC(self.iRegistViewModel, "Pwd")
        self.txtRePwd.rac_textSignal() ~> RAC(self.iRegistViewModel, "RePwd")

        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "RegistCheckProtocol")
        self.CheckBox.addGestureRecognizer(singleTap)
        
             self.btnChooseRole!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(self.popDownListForIphone == nil){
                    
                    self.popDownListForIphone = PopDownListForIphone()
                    self.popDownListForIphone?.delegate = self
                }
                self.popDownListForIphone?.Show("选择养老院/医院", source:self.iRegistViewModel!.MainBusinesses)
        }
        
        self.btnChooseType!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                if(self.TypeListForIphone == nil){
                    
                    self.TypeListForIphone = PopDownListForIphone()
                    self.TypeListForIphone?.delegate = self
                }
                self.TypeListForIphone?.Show("选择账户类型", source:self.iRegistViewModel!.TypeBusinesses)
        }
        
    }
    
//    func ReadProtocol(){
//        let jumpPage = IWebViewController(nibName:"WebView",bundle:nil,titleName:"用户服务协议",url:"http://www.usleepcare.com/app/protocol.aspx")
//        IViewControllerManager.GetInstance()!.ShowViewController(jumpPage, nibName: "WebView",reload: true)
//    }
    
    func RegistCheckProtocol(){
        //打勾选中，则跳转服务协议页面
        if(self.checkBoxImageName == "default_registUncheck.png"){
            self.checkBoxImageName = "default_registCheck.png"
            self.CheckBox.image = UIImage(named:self.checkBoxImageName)
            self.iRegistViewModel.IsChecked = true
        }
        else if(self.checkBoxImageName == "default_registCheck.png"){
            self.checkBoxImageName = "default_registUncheck.png"
            self.CheckBox.image = UIImage(named:self.checkBoxImageName)
            self.iRegistViewModel.IsChecked = false
        }
    }
    
    func ChoosedItem(item:PopDownListItem){
        if (item.value == "使用者" || item.value == "监护人")
        {
        self.iRegistViewModel.LoginType = item.key!
            self.txtType.text = item.value
        }
        else{
        self.iRegistViewModel.MainCode = item.key!
        self.txtMain.text = item.value
        }
    }
    

}
