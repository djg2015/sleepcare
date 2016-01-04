//
//  SoftwareUpdateController.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 1/4/16.
//  Copyright (c) 2016 djg. All rights reserved.
//

import UIKit

class SoftwareUpdateController: IBaseViewController {
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnCheckUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblVersion.text = UpdateHelper.GetUpdateInstance().dealVersion()
        // Do any additional setup after loading the view.
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ClickBack")
        self.imgBack.addGestureRecognizer(singleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func ClickBack(){
        IViewControllerManager.GetInstance()!.CloseViewController()
    }
    
    
    @IBAction func CheckUpdate(sender:AnyObject){
      UpdateHelper.GetUpdateInstance().CheckUpdate()
    }
}
