//
//  IFirstChoosePatientController.swift
//  
//
//  Created by djg on 15/11/16.
//
//

import UIKit

class ISetUserTypeController: IBaseViewController {

    @IBOutlet weak var btnMonitor: BlueButtonForPhone!
    @IBOutlet weak var btnUserSelf: BlueButtonForPhone!
    var viewModel:ISetUserTypeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeColor[themeName]
        self.viewModel = ISetUserTypeViewModel()
        self.btnUserSelf.rac_command = self.viewModel.userselfCommand
        self.btnMonitor.rac_command = self.viewModel.monitorCommand
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
