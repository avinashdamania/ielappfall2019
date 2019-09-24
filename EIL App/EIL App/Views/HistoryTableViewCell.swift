//
//  HistoryTableViewCell.swift
//  EIL App
//
//  Created by STEPAN ULYANIN on 4/13/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    // props
    @IBOutlet weak var lblBuilding: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
