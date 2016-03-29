//
//  FavoriteTableViewCell.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/28/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
