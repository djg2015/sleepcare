//
//  SleepCareTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/24.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepCareTableViewCell: UITableViewCell {
    var bedNumber:UILabel!
    
    init(data:String,reuseIdentifier cellID:String){
       self.bedNumber = UILabel()
       self.bedNumber.text = data
        super.init(style:UITableViewCellStyle.Default, reuseIdentifier: cellID)
        rebuilderUserInterface()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //汇至床位界面
    func rebuilderUserInterface(){
        self.addSubview(self.bedNumber)
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
