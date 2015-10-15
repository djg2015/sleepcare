//
//  AlarmTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCellLeaveTimespan: UILabel!
    
    @IBOutlet weak var lblCellLeaveTime: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.lblCellLeaveTimespan.layer.borderWidth = 1
//        self.lblCellLeaveTimespan.layer.borderColor = UIColor.lightGrayColor().CGColor
//        self.lblCellLeaveTimespan.frame.size = CGSize(width: self.frame.width/2 + 1, height: self.frame.height)
//        
//        self.lblCellLeaveTime.layer.borderWidth = 1
//        self.lblCellLeaveTime.layer.borderColor = UIColor.lightGrayColor().CGColor
//        self.lblCellLeaveTime.frame.size = CGSize(width: self.frame.width/2, height: self.frame.height)
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
