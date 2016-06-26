//
//  TabbarController.swift
//  
//
//  Created by Qinyuan Liu on 4/20/16.
//
//

import UIKit

class RootTabbarController: UITabBarController{
    var cellindex:Int = -1
     var selecthrImage = UIImage(named:"tab_心率－2.png")
     var selectrrImage = UIImage(named:"tab_呼吸－2.png")
     var selectsleepImage = UIImage(named:"tab_睡眠－2.png")
     var selectmeImage = UIImage(named:"tab_我的－2.png")
    
    @IBAction func UnwindShowEquipmentDetail(unwindsegue:UIStoryboardSegue){
     
        self.selectedIndex = 0
       
    }
   
    @IBAction func UnwindMydevice(unwindsegue:UIStoryboardSegue){
      self.selectedIndex = 3
        
    }
    
    @IBAction func UnwindAlarminfo(unwindsegue:UIStoryboardSegue){
        
       self.selectedIndex = 3
    }
    
    @IBAction func UnwindWeekreport(unwindsegue:UIStoryboardSegue){
        
         self.selectedIndex = 3
    }
    
    @IBAction func UnwindAbout(unwindsegue:UIStoryboardSegue){
        
         self.selectedIndex = 3
    }
    @IBAction func UnwindSkill(unwindsegue:UIStoryboardSegue){
        
         self.selectedIndex = 3
    }
    @IBAction func UnwindAccountinfo(unwindsegue:UIStoryboardSegue){
        
         self.selectedIndex = 3
    }

    //每次页面显示时执行。如果curEquipmentCode＝＝nil，默认选择“我”；不为空，选择“心率”
    override func viewWillAppear(animated:Bool) {
//        if SessionForSingle.GetSession()?.EquipmentList.count == 0{
//            self.selectedIndex = 3
//        }
    self.selectedIndex = 3
    }

    override func viewDidLoad() {
       //去除选中图片背景蓝色tint
        selecthrImage = selecthrImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectrrImage = selectrrImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectsleepImage = selectsleepImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectmeImage = selectmeImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
      self.selectedIndex = 0
      self.tabBar.selectedItem?.selectedImage = selecthrImage
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        switch item.tag{
        case 1:
          
            self.selectedIndex = 0
            item.selectedImage = selecthrImage
            
        case 2:
            
                self.selectedIndex = 1
            item.selectedImage = selectrrImage
            
        case 3:
             self.selectedIndex = 2
            item.selectedImage = selectsleepImage
        case 4:
             self.selectedIndex = 3
            item.selectedImage = selectmeImage
            
        default:
            print("未知按钮")
        }
    }

}

