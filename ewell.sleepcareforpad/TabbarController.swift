//
//  TabbarController.swift
//  
//
//  Created by Qinyuan Liu on 4/20/16.
//
//

import UIKit

class TabbarController: UITabBarController{
   
    
    @IBAction func UnwindShowPatientDetail(unwindsegue:UIStoryboardSegue){
        
        
    }
   
    //每次页面显示时执行。如果curPatientCode＝＝nil，默认选择“我”；不为空，选择“心率”
    override func viewWillAppear(animated:Bool) {
    
        if (SessionForIphone.GetSession()?.CurPatientCode == "") {
            self.selectedIndex = 3
       }
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
      //为“我”的图标加载badge number
        if IAlarmHelper.GetAlarmInstance().Warningcouts > 0{
            let tabbar = self.viewControllers!.last as! MyConfigueTableViewController
        tabbar.tabBarItem.badgeValue = String(IAlarmHelper.GetAlarmInstance().Warningcouts)
       
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        switch item.tag{
        case 1:
            if SessionForIphone.GetSession()?.CurPatientCode == ""{
                showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder))
            }
            
            self.selectedIndex = 0
            
        case 2:
            if SessionForIphone.GetSession()?.CurPatientCode == ""{
                showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder))
            }
           
                self.selectedIndex = 1
           
        case 3:
            if SessionForIphone.GetSession()?.CurPatientCode == ""{
                showDialogMsg(ShowMessage(MessageEnum.ChoosePatientReminder))
            }
           
                self.selectedIndex = 2
            
        case 4:
            self.selectedIndex = 3
            
        default:
            print("未知按钮")
        }
    }

}

