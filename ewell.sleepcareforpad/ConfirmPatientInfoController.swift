//
//  ConfirmPatientInfoController.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//

import UIKit

class ConfirmPatientInfoController: UIViewController ,UITextViewDelegate{
 var qrcode:String = ""
    var patientinfoViewModel: PatientInfoViewModel!
    var parentController:AddDeviceViewController!
    
    @IBOutlet weak var telephoneText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    

    override func viewWillAppear(animated: Bool) {
        currentController = self
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
        self.addressText.delegate = self
        self.patientinfoViewModel = PatientInfoViewModel()
        self.patientinfoViewModel.qrCode = self.qrcode
        self.patientinfoViewModel.parentController = self
        self.patientinfoViewModel.GetEquipmentInfo()
        
        self.maleBtn.setBackgroundImage(UIImage(named: "icon_male.png"), forState: UIControlState.Normal)
        self.maleBtn.setBackgroundImage(UIImage(named: "icon_male_choose.png"), forState: UIControlState.Selected)
        self.femaleBtn.setBackgroundImage(UIImage(named: "icon_female.png"), forState: UIControlState.Normal)
        self.femaleBtn.setBackgroundImage(UIImage(named: "icon_female_choose.png"), forState: UIControlState.Selected)
        
        self.confirmBtn.rac_command = self.patientinfoViewModel.confirmCommand
        self.maleBtn.rac_command = self.patientinfoViewModel.clickMaleCommand
        self.femaleBtn.rac_command = self.patientinfoViewModel.clickFemaleCommand
        
        
        RACObserve(self.patientinfoViewModel, "Telephone") ~> RAC(self.telephoneText, "text")
        RACObserve(self.patientinfoViewModel, "Name") ~> RAC(self.nameText, "text")
        RACObserve(self.patientinfoViewModel, "Address") ~> RAC(self.addressText, "text")
        self.nameText.rac_textSignal() ~> RAC(self.patientinfoViewModel, "Name")
        self.telephoneText.rac_textSignal() ~> RAC(self.patientinfoViewModel, "Telephone")
        self.addressText.rac_textSignal() ~> RAC(self.patientinfoViewModel, "Address")
        
        RACObserve(self.patientinfoViewModel, "IsMale") ~> RAC(self.maleBtn, "selected")
        RACObserve(self.patientinfoViewModel, "IsFemale") ~> RAC(self.femaleBtn, "selected")
        
        
       

    }
    
    //textview回车，收起键盘
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text.isEqual("\n")) {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
