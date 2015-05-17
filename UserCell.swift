//
//  UserCell.swift
//  CyPhyBitDate3
//
//  Created by Matt Linaberry on 5/16/15.
//  Copyright (c) 2015 Matt Linaberry. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
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
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
    }

}
