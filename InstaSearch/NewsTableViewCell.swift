//
//  NewsTableViewCell.swift
//  InstaSearch
//
//  Created by 鈴木治 on 2015/08/08.
//  Copyright (c) 2015年 Plegineer Inc. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!;
    @IBOutlet weak var dateLabel: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
