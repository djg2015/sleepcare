//
//  ChangePatientInfoController.swift
//  
//
//  Created by Qinyuan Liu on 6/29/16.
//
//

import UIKit

class ChangePatientInfoController: IBaseViewController,UITextViewDelegate {
    
    var changepatientViewModel:ChangePatientInfoViewModel!
    
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
        self.changepatientViewModel = ChangePatientInfoViewModel()
        self.changepatientViewModel.parentController = self
        self.changepatientViewModel.GetEquipmentInfo()
        
        self.maleBtn.setBackgroundImage(UIImage(named: "icon_male.png"), forState: UIControlState.Normal)
        self.maleBtn.setBackgroundImage(UIImage(named: "icon_male_choose.png"), forState: UIControlState.Selected)
        self.femaleBtn.setBackgroundImage(UIImage(named: "icon_female.png"), forState: UIControlState.Normal)
        self.femaleBtn.setBackgroundImage(UIImage(named: "icon_female_choose.png"), forState: UIControlState.Selected)
        
        self.confirmBtn.rac_command = self.changepatientViewModel.confirmCommand
        self.maleBtn.rac_command = self.changepatientViewModel.clickMaleCommand
        self.femaleBtn.rac_command = self.changepatientViewModel.clickFemaleCommand
        
        
        RACObserve(self.changepatientViewModel, "Telephone") ~> RAC(self.telephoneText, "text")
        RACObserve(self.changepatientViewModel, "Name") ~> RAC(self.nameText, "text")
        RACObserve(self.changepatientViewModel, "Address") ~> RAC(self.addressText, "text")
        self.nameText.rac_textSignal() ~> RAC(self.changepatientViewModel, "Name")
        self.telephoneText.rac_textSignal() ~> RAC(self.changepatientViewModel, "Telephone")
        self.addressText.rac_textSignal() ~> RAC(self.changepatientViewModel, "Address")
        
        RACObserve(self.changepatientViewModel, "IsMale") ~> RAC(self.maleBtn, "selected")
        RACObserve(self.changepatientViewModel, "IsFemale") ~> RAC(self.femaleBtn, "selected")
        
        
        
        
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
