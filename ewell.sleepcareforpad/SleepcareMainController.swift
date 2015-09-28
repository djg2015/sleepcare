//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainController: BaseViewController {
    
    var tableView:SleepCareTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = SleepCareTableView(frame: CGRectMake(0, 20, self.view.frame.width, self.view.frame.height))
        self.tableView.registerClass(SleepCareTableViewCell.self, forCellReuseIdentifier: "mycell")
        // Do any additional setup after loading the view.
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
