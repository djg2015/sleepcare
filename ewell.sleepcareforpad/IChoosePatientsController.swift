//
//  IChoosePatients.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
class IChoosePatientsController: IBaseViewController {
    @IBOutlet weak var tbParts: CommonTableView!
    @IBOutlet weak var tbPatients: CommonTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.myPatientsTableView = MyPatientsTableView(frame: CGRectMake(0, 0, uiPatientList.frame.width, uiPatientList.accessibilityFrame.height))
        
        self.tbParts.ShowTableView("PartTableCell",cellID: "partCell", source: ["1号楼","2号楼","3号楼"], cellHeight: 100)
        self.tbPatients.ShowTableView("PartTableCell", cellID: "PatientCell",source: ["1号楼","2号楼","3号楼"], cellHeight: 100)
        //        self.uiPatientList.addSubview(self.myPatientsTableView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}