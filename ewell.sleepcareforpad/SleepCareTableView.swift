//
//  SleepCareTableView.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepCareTableView: UITableView,UITableViewDelegate,UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame,style:UITableViewStyle.Plain)
        self.backgroundColor = UIColor.blueColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.delegate = self
        self.dataSource? = self
    }
    

    required init(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    //返回指定分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //返回表格总列数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellID = "bedcell"
        
        if(indexPath.row > 0){
            return SleepCareTableViewCell(data: "hello", reuseIdentifier: cellID)
        }
        else{
            return UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: cellID)
        }
    }

}
