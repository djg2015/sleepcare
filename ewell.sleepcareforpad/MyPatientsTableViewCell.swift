//
//  SleepCareTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class MyPatientsTableViewCell: UITableViewCell {
 
    init(data:String,reuseIdentifier cellID:String){
      
        super.init(style:UITableViewCellStyle.Subtitle, reuseIdentifier: cellID)
        rebuilderUserInterface()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //汇至床位界面
    func rebuilderUserInterface(){
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
