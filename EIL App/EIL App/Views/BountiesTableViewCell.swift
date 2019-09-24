//
//  BountiesTableViewCell.swift
//  EIL App
//
//  Created by STEPAN ULYANIN on 4/12/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit

class BountiesTableViewCell: UITableViewCell {

    // outlets
    @IBOutlet weak var lblBuilding: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblFloor: UILabel!
    @IBOutlet weak var lblId: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
