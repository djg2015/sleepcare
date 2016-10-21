//
//  TabbarController.swift
//
//
//  Created by Qinyuan Liu on 4/20/16.
//
//

import UIKit

class TabbarController: UITabBarController{
    var cellindex:Int = -1
    var selecthrImage = UIImage(named:"icon_heart_rate_")
    var selectrrImage = UIImage(named:"icon_breath_blue_")
    var selectsleepImage = UIImage(named:"icon_sleep_blue_")
    var selectedImage:UIImage!
    

    override func viewDidLoad() {
        //去除选中图片背景蓝色tint
        selecthrImage = selecthrImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectrrImage = selectrrImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        selectsleepImage = selectsleepImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
     
        self.selectedIndex = 0
        selectedImage = selecthrImage
        self.tabBar.selectedItem?.selectedImage = selectedImage
        
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
      
            
        default:
            print("未知按钮")
        }
    }
    
}

