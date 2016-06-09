//
//  UserDetailListCell.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/9/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class UserDetailListCell: UITableViewCell {
    
    @IBOutlet var number: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var workplace: UILabel!
    @IBOutlet var numberOfTimes: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var contact: UILabel!
    @IBOutlet var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.number.adjustsFontSizeToFitWidth = true;
        self.name.adjustsFontSizeToFitWidth = true;
        self.nickname.adjustsFontSizeToFitWidth = true;
        self.gender.adjustsFontSizeToFitWidth = true;
        self.age.adjustsFontSizeToFitWidth = true;
        self.workplace.adjustsFontSizeToFitWidth = true;
        self.numberOfTimes.adjustsFontSizeToFitWidth = true;
        self.time.adjustsFontSizeToFitWidth = true;
        self.contact.adjustsFontSizeToFitWidth = true;
        self.price.adjustsFontSizeToFitWidth = true;

        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
