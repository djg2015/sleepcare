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
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.delegate = self
        self.dataSource = self
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
        return 2
    }
    
    //返回单元格的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    //自定义单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellID = "mycell"
        
        return SleepCareTableViewCell(data: "hello", reuseIdentifier: cellID)
        
    }
    
    //根据数据绑定重载当前表格
    override func reloadData() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        super.reloadData()
    }
    
}
