//
//  SettingTableViewCell.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/22/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.textAlignment = NSTextAlignment.left
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
