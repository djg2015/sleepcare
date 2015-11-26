//
//  PopDownList.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/30.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

//弹出式下拉列表
class PopDownList:NSObject,UITableViewDelegate,UITableViewDataSource{
    var _dataSource = Array<DownListModel>()
    private var popover: Popover!
    private var popoverOptions: [PopoverOption] = [
        .Type(.Down),
        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    private var didDismissHandler: ((downListModel:DownListModel) -> ())?
    
    init(datasource:Array<DownListModel>,dismissHandler: ((downListModel:DownListModel) -> ())?){
        self._dataSource = datasource
        self.didDismissHandler = dismissHandler
    }
    
    func Show(width:CGFloat,height:CGFloat,uiElement:UIView){
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.popover = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
        self.popover.show(tableView, fromView: uiElement)
    }
    
    func Show(width:CGFloat,uiElement:UIView){
        let height:CGFloat = CGFloat(self._dataSource.count * 45)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.popover = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
        self.popover.show(tableView, fromView: uiElement)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        self.popover.dismiss()
        if(self.didDismissHandler != nil){
            self.didDismissHandler!(downListModel: self._dataSource[indexPath.row])
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self._dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = self._dataSource[indexPath.row].value
        cell.textLabel?.font =  cell.textLabel?.font.fontWithSize(15)
        return cell
    }
}

class DownListModel {
    var key:String = ""
    var value:String = ""
}