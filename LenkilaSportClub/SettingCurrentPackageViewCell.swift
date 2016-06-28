//
//  SettingCurrentPackageViewCell.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/27/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class SettingCurrentPackageViewCell: UITableViewCell {

    @IBOutlet var iconPackage: UIImageView!
    @IBOutlet var packageName: UILabel!
    @IBOutlet var packageDate: UILabel!
    @IBOutlet var packageDayLeft: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
