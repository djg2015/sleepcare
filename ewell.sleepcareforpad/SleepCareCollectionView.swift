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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell:SleepCareCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("bedcell", forIndexPath: indexPath) as! SleepCareCollectionViewCell
        cell.rebuilderUserInterface()
        return cell
        
    }
    
    //根据数据绑定重载当前表格
    override func reloadData() {
        var cellNib =  UINib(nibName: "SleepCareCollectionViewCell", bundle: nil)
        self.registerNib(cellNib, forCellWithReuseIdentifier: "bedcell")
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.blueColor()
        self.delegate = self
        self.dataSource = self
        super.reloadData()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
