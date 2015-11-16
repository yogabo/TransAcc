//
//  CustomCell.swift
//  TransAcc
//
//  Created by Lubos Sytensky on 13/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//
//

import UIKit

class CustomCell: UITableViewCell {
    
    /// Customized cell for data table view list od accounts and transactions
    var accNum:String?
    var accName:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Configure the view for the selected state
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
