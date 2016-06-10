//
//  User.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 6/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm

class User:RLMObject{
    dynamic var id : String = ""
    dynamic var name : String = "ไม่มี"
    dynamic var nickName : String = ""
    dynamic var gender : String = "ไม่มี"
    dynamic var age : Int = 0
    dynamic var workPlace : String = "ไม่มี"
    dynamic var playCount : Int  = 0
    dynamic var freqPlay : String = "ไม่มี"
    dynamic var contact : String = ""
    dynamic var price : Int = 0
}