//
//  PartNameCell.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 2/19/16.
//  Copyright (c) 2016 djg. All rights reserved.
//
//
//  QuoteCell.swift
//  表格动画手势示例
//
//  Created by Semper Idem on 14-10-22.
//  Copyright (c) 2014年 星夜暮晨. All rights reserved.
//

import UIKit

class PartNameCell: UITableViewCell {
    
 
    @IBOutlet weak var lblpartname: UILabel!
    
    var quotation: Part!
    
  
    
    // 设置语录
    func setTheQuotation(newQuotation: Part) {
        
        quotation = newQuotation
        
        self.lblpartname.text = quotation.partname
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
