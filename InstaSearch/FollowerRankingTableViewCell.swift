//
//  FollowerRankingTableViewCell.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/06/03.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class FollowerRankingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var followerNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
