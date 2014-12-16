//
//  CustomTableViewCell.swift
//  educal
//
//  Created by Bastiaan van Weijen on 16-12-14.
//  Copyright (c) 2014 Jurriaan Lindhout. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var homeworkTitleLabel: UILabel!
    @IBOutlet weak var homeworkDeadlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
