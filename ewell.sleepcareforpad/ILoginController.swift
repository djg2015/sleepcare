//
//  ILoginController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/6.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class ILoginController: IBaseViewController,THDateChoosedDelegate {
    var datapicker:THDate?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnTest: UIButton!
    @IBAction func TouchButton(sender: AnyObject) {
        self.datapicker?.ShowDate()
         self.presentViewController(IMainFrameViewController(nibName:"IMainFrame", bundle:nil), animated: true, completion: nil)
    }
    
    func ChoosedDate(choosedDate:String?){
        self.lblDate.text = choosedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datapicker = THDate(parentControl: self)
        datapicker?.delegate = self
        // Do any additional setup after loading the view.
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
