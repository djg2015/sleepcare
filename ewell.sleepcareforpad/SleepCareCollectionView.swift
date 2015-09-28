//
//  SleepCareCollectionView.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/28.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepCareCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource  {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clearColor()
        self.delegate = self
        self.dataSource = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      return SleepCareCollectionViewCell(data: "test", reuseIdentifier: "bedcell")
      
    }
    
    //根据数据绑定重载当前表格
    override func reloadData() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
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
