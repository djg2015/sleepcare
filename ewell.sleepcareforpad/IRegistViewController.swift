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
    @IBOutlet weak var CheckBox: UIImageView!
    @IBOutlet weak var btnBack: BlueButtonForPhone!
    @IBOutlet weak var btnRegist: BlueButtonForPhone!
    @IBOutlet weak var btnChooseRole: UIButton!
    @IBOutlet weak var lblReadProtocol: UILabel!

    var popDownListForIphone:PopDownListForIphone?
    var iRegistViewModel:IRegistViewModel!
    var checkBoxImageName:String = "default_registUncheck.png"
    
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
    //-------------自定义方法处理---------------
    func rac_settings(){
        self.iRegistViewModel = IRegistViewModel()
        self.btnRegist!.rac_command = self.iRegistViewModel?.registCommand
        self.txtLoginName.rac_textSignal() ~> RAC(self.iRegistViewModel, "LoginName")
        self.txtPwd.rac_textSignal() ~> RAC(self.iRegistViewModel, "Pwd")
        self.txtRePwd.rac_textSignal() ~> RAC(self.iRegistViewModel, "RePwd")
        
        
        self.lblReadProtocol.userInteractionEnabled = true
        var Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ReadProtocol")
        self.lblReadProtocol.addGestureRecognizer(Tap)
        
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "RegistCheckProtocol")
        self.CheckBox.addGestureRecognizer(singleTap)
        
        self.btnBack!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                xmppMsgManager!.Close()
                IViewControllerManager.GetInstance()!.CloseViewController()
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
    
    func ReadProtocol(){
        let jumpPage = IWebViewController(nibName:"WebView",bundle:nil,titleName:"用户服务协议",url:"http://www.usleepcare.com/app/protocol.aspx")
        IViewControllerManager.GetInstance()!.ShowViewController(jumpPage, nibName: "WebView",reload: true)
    }
    
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
        self.iRegistViewModel.MainCode = item.key!
        self.txtMain.text = item.value
    }
    
}
