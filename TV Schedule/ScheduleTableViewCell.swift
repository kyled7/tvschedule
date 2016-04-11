//
//  ScheduleTableViewCell.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/22/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cellView.layer.borderColor = UIColor(white: 1, alpha: 0.4).CGColor
        cellView.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
