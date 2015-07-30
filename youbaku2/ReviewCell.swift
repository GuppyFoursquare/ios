//
//  ReviewCell.swift
//  youbaku2
//
//  Created by ULAKBIM on 28/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var content: UITextView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var subtitleLabel: UITextView!
    @IBOutlet var titleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.frame = CGRectMake(0,0,75.0,75.0)
    }
}
