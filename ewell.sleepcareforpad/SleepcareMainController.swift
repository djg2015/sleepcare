//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainController: BaseViewController {
    
    @IBOutlet weak var collection1: SleepCareCollectionView!
    @IBOutlet weak var collection: SleepCareCollectionView!
    var tableView:SleepCareTableView!
    var mainview:SleepCareCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.mainview = SleepCareCollectionView(frame: CGRectMake(0, 20, self.view.frame.width, self.view.frame.height), collectionViewLayout: UICollectionViewLayout())
   
//        // Do any additional setup after loading the view.
       self.collection.reloadData()
         self.collection1.reloadData()
//        self.view.addSubview(self.mainview)
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
