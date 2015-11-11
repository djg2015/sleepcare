//
//  IMainFrameViewController.swift
//
//
//  Created by djg on 15/11/10.
//
//

import UIKit

class IMainFrameViewController: IBaseViewController {
    @IBOutlet weak var uiHR: BackgroundCommon!
    @IBOutlet weak var uiRR: BackgroundCommon!
    @IBOutlet weak var uiSleepCare: BackgroundCommon!
    @IBOutlet weak var uiMe: BackgroundCommon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加主菜单点击事件
        self.uiHR.userInteractionEnabled = true
        var choosePart:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuTouch")
        self.uiHR .addGestureRecognizer(choosePart)
        
        self.uiRR.userInteractionEnabled = true
        var choosePart1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuTouch1")
        self.uiRR .addGestureRecognizer(choosePart1)
        
        self.uiSleepCare.userInteractionEnabled = true
        var choosePart2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuTouch2")
        self.uiSleepCare .addGestureRecognizer(choosePart2)
        
        self.uiMe.userInteractionEnabled = true
        var choosePart3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuTouch3")
        self.uiMe .addGestureRecognizer(choosePart3)
    }
    
    //菜单点击
    func menuTouch(){
    
    }
    
    //显示菜单界面
    func showBody(view:UIView){
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func FirstBtnClick(){
        
    }
    
    
    func SecondBtnClick(){
        
    }
    
    
    func ThirdBtnClick(){
        
    }
    
    func FourthBtnClick(){
        
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
