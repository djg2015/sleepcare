//
//  SleepCareCollectionView.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/28.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit
//主界面床位布局控件
class SleepCareCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource  {
    var _bedModelList:Array<BedModel> = []
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self._bedModelList.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell:SleepCareCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("bedcell", forIndexPath: indexPath) as! SleepCareCollectionViewCell
        cell.rebuilderUserInterface(self._bedModelList[indexPath.item])
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if(self.didSelecteBedHandler != nil){
            self.didSelecteBedHandler!(bedModel: self._bedModelList[indexPath.item])
        }
    }
    
    func reloadData(bedModelList:Array<BedModel>) {
        self._bedModelList = bedModelList
        self.reloadData()
    }
    
    //根据数据绑定重载当前表格
    override func reloadData() {
        //注册单元格内容
        var cellNib =  UINib(nibName: "SleepCareCollectionViewCell", bundle: nil)
        self.registerNib(cellNib, forCellWithReuseIdentifier: "bedcell")
        
        //设置当前表格控件
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.clearColor()
        self.delegate = self
        self.dataSource = self
        super.reloadData()
    }
    
    
    
    //床位点击命令
    var didSelecteBedHandler: ((bedModel:BedModel) -> ())?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
