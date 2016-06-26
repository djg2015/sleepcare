//
//  EquipmentViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/1/16.
//
//

import UIKit

class EquipmentViewController: UIViewController,UITextViewDelegate {
    var qrcode:String = ""
    var registcontroller:RootRegistViewController!
    var equipmentViewModel:EquipmentViewModel!
    
    @IBOutlet weak var telephoneText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    
 
    
    
    override func viewWillAppear(animated: Bool) {
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rac_settings()
            print(self.qrcode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rac_settings(){
        self.addressText.delegate = self
        self.equipmentViewModel = EquipmentViewModel()
        self.equipmentViewModel.qrCode = self.qrcode
        self.equipmentViewModel.parentController = self
       
        
        self.maleBtn.setBackgroundImage(UIImage(named: "icon_male.png"), forState: UIControlState.Normal)
        self.maleBtn.setBackgroundImage(UIImage(named: "icon_male_choose.png"), forState: UIControlState.Selected)
        self.femaleBtn.setBackgroundImage(UIImage(named: "icon_female.png"), forState: UIControlState.Normal)
        self.femaleBtn.setBackgroundImage(UIImage(named: "icon_female_choose.png"), forState: UIControlState.Selected)

        self.confirmBtn.rac_command = self.equipmentViewModel.confirmCommand
        self.maleBtn.rac_command = self.equipmentViewModel.clickMaleCommand
        self.femaleBtn.rac_command = self.equipmentViewModel.clickFemaleCommand
        
    
        RACObserve(self.equipmentViewModel, "Telephone") ~> RAC(self.telephoneText, "text")
        RACObserve(self.equipmentViewModel, "Name") ~> RAC(self.nameText, "text")
        RACObserve(self.equipmentViewModel, "Address") ~> RAC(self.addressText, "text")
        self.nameText.rac_textSignal() ~> RAC(self.equipmentViewModel, "Name")
        self.telephoneText.rac_textSignal() ~> RAC(self.equipmentViewModel, "Telephone")
         self.addressText.rac_textSignal() ~> RAC(self.equipmentViewModel, "Address")
        
        RACObserve(self.equipmentViewModel, "IsMale") ~> RAC(self.maleBtn, "selected")
        RACObserve(self.equipmentViewModel, "IsFemale") ~> RAC(self.femaleBtn, "selected")
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
