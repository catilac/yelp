//
//  BoolFilterCell.swift
//  Yelp
//
//  Created by Chirag Davé on 4/27/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BoolFilterCell: UITableViewCell {

    @IBOutlet weak var boolSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
