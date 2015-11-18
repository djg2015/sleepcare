//
//  IMyPatientsController.swift
//  
//
//  Created by djg on 15/11/17.
//
//

import UIKit

class IMyPatientsController: IBaseViewController {
    @IBOutlet weak var imgSmallAdd: UIImageView!
    @IBOutlet weak var imgBigAdd: UIImageView!
    @IBOutlet weak var uiNewAdd: UIView!
    @IBOutlet weak var uiPatientList: UIView!
    
    var myPatientsTableView:MyPatientsTableView!
    @IBOutlet weak var myPatientTable: MyPatientsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myPatientTable.reloadData()
        
        //设置添加老人事件
        self.imgSmallAdd.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgSmallAdd .addGestureRecognizer(singleTap)
        
//        self.imgBigAdd.userInteractionEnabled = true
//        self.imgBigAdd .addGestureRecognizer(singleTap)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //弹出添加老人界面
    func imageViewTouch(){
        var controller = IChoosePatientsController(nibName:"IChoosePatients", bundle:nil)
        self.presentViewController(controller, animated: true, completion: nil)


    }
    


}
