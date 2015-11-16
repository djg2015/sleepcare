//
//  IFirstChoosePatientController.swift
//  
//
//  Created by djg on 15/11/16.
//
//

import UIKit

class IFirstChoosePatientController: IBaseViewController {

    @IBOutlet weak var btnMonitor: BlueButtonForPhone!
    @IBOutlet weak var btnUserSelf: BlueButtonForPhone!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //选择用户类型
    @IBAction func userTypeCilcked(sender: AnyObject) {
        
        
        //更新session
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
