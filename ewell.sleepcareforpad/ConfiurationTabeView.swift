//
//  ConfiurationTabeView.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

class ConfiurationTabeView: UITableView, UITableViewDelegate,UITableViewDataSource{
    
    var tableViewDataSource:Array<ConfigurationViewModel> = Array<ConfigurationViewModel>()
    var showMenuImage:Bool = true
    let identifier = "CellIdentifier"
    var parentController:IBaseViewController?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clearColor()
    }
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewDataSource.count
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        
        cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        
        var cellView = UIView(frame: CGRect(x: -1, y: 0, width: self.bounds.width + 2, height: 50))
        cellView.backgroundColor = self.backgroundColor
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).CGColor
        
        // 添加操作菜单名称
        var txtTitle = UILabel(frame: CGRect(x: 15, y: 0, width: self.bounds.width - 65 * 2, height: 50))
        txtTitle.text = self.tableViewDataSource[indexPath.row].titleName
        txtTitle.font = UIFont.boldSystemFontOfSize(18)
        txtTitle.textAlignment = .Left
        cellView.addSubview(txtTitle)

         // 添加图片
        if(self.showMenuImage)
        {
            var imgMenu = UIImageView(frame: CGRect(x: 85, y: 7, width: 30, height: 30))
            imgMenu.image = UIImage(named: self.tableViewDataSource[indexPath.row].imageName)
            cellView.addSubview(imgMenu)
        }
        
        // 添加跳转箭头
        if(self.tableViewDataSource[indexPath.row].titleName != "软件版本"){
        var imgJump = UIImageView(frame: CGRect(x: self.bounds.width - 45, y: 10, width: 30, height: 30))
        imgJump.image = UIImage(named: "detailBtn")
        cellView.addSubview(imgJump)
        }
        else{
        var versionlbl = UILabel(frame: CGRect(x: self.bounds.width - 60, y: 10, width: 50, height: 30))
            versionlbl.text = "2.0.0"
            versionlbl.font = UIFont.boldSystemFontOfSize(18)
            versionlbl.textAlignment = .Center
            cellView.addSubview(versionlbl)
        }
        
        cellView.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "jumpController:")
        cellView.addGestureRecognizer(singleTap)
        singleTap.view?.tag = indexPath.row      
        
        cell!.addSubview(cellView)
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49
    }
    
    func jumpController(sender:UITapGestureRecognizer)
    {
        var selectedNumber:Int = sender.view!.tag
        var controller:IBaseViewController = self.tableViewDataSource[selectedNumber].configrationController
        if(controller.nibName != nil)
        {
            if controller.nibName! == "IAlarmView"{
            controller = IAlarmViewController(nibName:"IAlarmView", bundle:nil)
            }
           
            IViewControllerManager.GetInstance()!.ShowViewController(controller, nibName: controller.nibName!, reload: true)
        }
    }
}

class ConfigurationViewModel {
    var imageName:String = ""
    var titleName:String = ""
    var configrationController:IBaseViewController = IBaseViewController()
}