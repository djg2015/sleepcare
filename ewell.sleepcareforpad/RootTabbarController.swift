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
     var selecthrImage = UIImage(named:"tab_心率_2")
     var selectrrImage = UIImage(named:"tab_呼吸_2")
     var selectsleepImage = UIImage(named:"tab_睡眠_2")
     var selectmeImage = UIImage(named:"tab_我的_2")
    
  
    @IBAction func UnwindChangePatientInfo(unwindsegue:UIStoryboardSegue){
        
       
    }
    @IBAction func UnwindMyDevice(unwindsegue:UIStoryboardSegue){
        
        
    }
    @IBAction func UnwindWeekReport(unwindsegue:UIStoryboardSegue){
        
        
    }
    @IBAction func UnwindAbout(unwindsegue:UIStoryboardSegue){
        
        
    }
    @IBAction func UnwindTips(unwindsegue:UIStoryboardSegue){
        
        
    }
    @IBAction func UnwindAccountSetting(unwindsegue:UIStoryboardSegue){
        
        
    }
    
    //每次页面显示时执行。如果curEquipmentCode＝＝nil，默认选择“我”；不为空，选择“心率”
    override func viewWillAppear(animated:Bool) {
        if SessionForSingle.GetSession()?.EquipmentList.count == 0{
            self.selectedIndex = 3
            self.tabBar.selectedItem?.selectedImage = selectmeImage
          
        }
            //有未读的报警信息，则默认选择“我的”页面
        else if(IAlarmHelper.GetAlarmInstance().WarningList.count>0){
        self.selectedIndex = 3
            self.tabBar.selectedItem?.selectedImage = selectmeImage
            self.tabBar.selectedItem?.badgeValue = String(IAlarmHelper.GetAlarmInstance().WarningList.count)
        }
      
        else{
            self.selectedIndex = 0
            self.tabBar.selectedItem?.selectedImage = selecthrImage

        }
    }

    override func viewDidLoad() {
        //去除选中图片背景蓝色tint
        selecthrImage = selecthrImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectrrImage = selectrrImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectsleepImage = selectsleepImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectmeImage = selectmeImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
      
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

