//
//  PopDownListForIphone.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/11/12.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
class PopDownListForIphone:NSObject,ZSYPopoverListDatasource, ZSYPopoverListDelegate {
    var _source:Array<PopDownListItem> = Array<PopDownListItem>()
    let identifier:String = "identifier"
    var selectedIndexPath:NSIndexPath!
    var selectedCode:String!
    var listView:ZSYPopoverListView?
    var delegate:PopDownListItemChoosed!
    func Show(title:String,source:Array<PopDownListItem>){
        self._source = source
        if(listView == nil){
            listView = ZSYPopoverListView(frame: CGRectMake(0, 0, 300, 200))
            listView!.titleName.text = title
            listView!.datasource = self
            listView!.delegate = self
        }        
        listView!.show()
    }
    
    func Show(title:String,source:Array<PopDownListItem>,selectedCode:String){
        self._source = source
        self.selectedCode = selectedCode
        if(listView == nil){
            listView = ZSYPopoverListView(frame: CGRectMake(0, 0, 300, 200))
            listView!.titleName.text = title
            listView!.datasource = self
            listView!.delegate = self
        }
        listView!.show()
    }
    
    func popoverListView(tableView:ZSYPopoverListView,numberOfRowsInSection section:NSInteger) -> NSInteger{
        return _source.count
    }
    
    
    func popoverListView(tableView:ZSYPopoverListView,cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell? = tableView.dequeueReusablePopoverCellWithIdentifier(identifier) as? UITableViewCell
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        if (self.selectedIndexPath != nil && self.selectedIndexPath == indexPath)
        {
            cell!.imageView!.image = UIImage(named: "fs_main_login_selected.png")
        }
        else
        {
            cell!.imageView!.image = UIImage(named: "fs_main_login_normal.png")
        }
        
        if(self.selectedCode != nil){
            if(self.selectedCode ==  _source[indexPath.row].key){
                cell!.imageView!.image = UIImage(named: "fs_main_login_selected.png")
            }
        }
        cell!.textLabel!.text = _source[indexPath.row].value
        return cell!
    }
    
    func popoverListView(tableView:ZSYPopoverListView,didSelectRowAtIndexPath indexPath:NSIndexPath){
        var cell:UITableViewCell = tableView.popoverCellForRowAtIndexPath(indexPath)
        cell.imageView!.image = UIImage(named: "fs_main_login_selected.png")
        self.selectedIndexPath = indexPath
       
        if(self.delegate != nil){
            self.delegate.ChoosedItem(_source[indexPath.row])
        }
        self.listView?.dismiss()
    }
    
    func popoverListView(tableView:ZSYPopoverListView,didDeselectRowAtIndexPath indexPath:NSIndexPath){
        
        var cell:UITableViewCell? = tableView.popoverCellForRowAtIndexPath(indexPath)
        cell?.imageView!.image = UIImage(named: "fs_main_login_normal.png")
    }
}

struct PopDownListItem {
    var key:String?
    var value:String?
}

protocol PopDownListItemChoosed{
    func ChoosedItem(item:PopDownListItem)
}