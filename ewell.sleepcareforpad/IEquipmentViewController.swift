//
//  IEquipmentViewController.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/20.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class IEquipmentViewController: IBaseViewController {
    
    @IBOutlet weak var lblEquipmentID: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var backBtn: UIImageView!
    var equipmentViewModel:IEquipmentViewModel?
    var equipmentID:String?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?,equipmentID:String) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.equipmentID = equipmentID
    }
    
    override func viewDidLoad() {
        
        self.equipmentViewModel = IEquipmentViewModel()
        self.equipmentViewModel?.EquipmentID = self.equipmentID
        
        RACObserve(self.equipmentViewModel, "EquipmentID") ~> RAC(self.lblEquipmentID, "text")
        RACObserve(self.equipmentViewModel, "Status") ~> RAC(self.lblStatus, "text")
        
        self.backBtn.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backToController:")
        self.backBtn.addGestureRecognizer(singleTap)
    }
    
    func backToController(sender:UITapGestureRecognizer)
    {
        IViewControllerManager.GetInstance()!.CloseViewController()
       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}