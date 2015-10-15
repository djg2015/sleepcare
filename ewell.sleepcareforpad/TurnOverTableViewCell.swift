//
//  TurnOverTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/14.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class TurnOverTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTurnOverTimes: UILabel!
    
    @IBOutlet weak var lblTurnOverRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
