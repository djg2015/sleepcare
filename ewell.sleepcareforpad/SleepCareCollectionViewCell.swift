//
//  SleepCareCollectionViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/28.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepCareCollectionViewCell: UICollectionViewCell {
    var bedNumber:UILabel!
    
    init(data:String,reuseIdentifier cellID:String){
        self.bedNumber = UILabel(frame:CGRectMake(10, 10, 100, 30))
        self.bedNumber.text = data
        super.init(coder: NSCoder())
        rebuilderUserInterface()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //汇至床位界面
    func rebuilderUserInterface(){
        self.backgroundColor = UIColor.redColor()
        self.addSubview(self.bedNumber)
    }

}
