//
//  Pager.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/8.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//分页控件
@IBDesignable class Pager: UIView {
    var detegate:JumpPageDelegate!
    var selectedButton:UIButton!
    @IBInspectable var pageCount:Int = 0{
        didSet{
            self.CleanSubviews()
            self.setView()
        }
        
    }
    
    func CleanSubviews(){
       while(self.subviews.count > 0){
            self.subviews[0].removeFromSuperview()
        }
    }
    
    //初始化分页控件
    func setView(){
        let width:CGFloat = 20.0
        let height:CGFloat = 20.0
        let span:CGFloat = 5.0
        let top = (self.frame.height / 2) - (height / 2)
        let pagerWidth = width * CGFloat(pageCount) + span * (CGFloat(pageCount) - 1)
        let firLeft = (self.frame.width / 2) - (pagerWidth / 2)
        if(self.pageCount > 0){
            for i in 1...self.pageCount{
                var pager = UIButton()
                let left = firLeft + span * CGFloat(i - 1) + (width * CGFloat(i))
                pager.frame = (CGRect(origin: CGPointMake(left, top), size: CGSizeMake(width,height)))
                pager.backgroundColor = UIColor.clearColor()
                if(i == 1){
                    pager.setBackgroundImage(UIImage(named: "pagerselected"), forState:.Normal)
                    selectedButton = pager
                }
                else{
                    pager.setBackgroundImage(UIImage(named: "pagerunselected"), forState:.Normal)
                }
                pager.addTarget(self, action:"jumpPage:", forControlEvents: UIControlEvents.TouchUpInside)
                pager.tag = i
                self.addSubview(pager)
                
            }
        }
    }
    
    //往前滚动一页
    func go(){
        var curIndex = self.selectedButton.tag
        if(self.subviews.count > curIndex){
            jumpPage(self.subviews[curIndex] as! UIButton)
        }
    }
    
    //往后滚动一页
    func back(){
        var curIndex = self.selectedButton.tag
        if(curIndex > 1){
            jumpPage(self.subviews[curIndex - 2] as! UIButton)
        }
        
    }
    
    //分页按钮选中
    func jumpPage(sender: UIButton!) {
        selectedButton.setBackgroundImage(UIImage(named: "pagerunselected"), forState:.Normal)
        sender.setBackgroundImage(UIImage(named: "pagerselected"), forState:.Normal)
        selectedButton = sender
        if(self.detegate != nil){
            var source = sender.tag
            self.detegate.JumpPage(source)
        }
    }
    
    //外部调用，页码跳转
    func jump(page:Int) {
        //搜索房间号／床位号若不存在，subview＝0
        if self.subviews.count >= page {
        var sender = self.subviews[page-1] as! UIButton
        selectedButton.setBackgroundImage(UIImage(named: "pagerunselected"), forState:.Normal)
        sender.setBackgroundImage(UIImage(named: "pagerselected"), forState:.Normal)
        selectedButton = sender
        }
    }
    
}

protocol JumpPageDelegate{
    func JumpPage(pageIndex:NSInteger)
}
