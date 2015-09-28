//
//  SleepCareCollectionView.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/28.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepCareCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource  {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 1
    }
    
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
      return UICollectionViewCell()
      
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
