//
//  Setting.swift
//  LenkilaClub
//
//  Created by Tanakorn on 7/22/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Setting:RLMObject{
    dynamic var username : String = ""
    dynamic var password : String = ""
    dynamic var already_login : Bool = false
    dynamic var num_field : Int = 0
    dynamic var sportClub_id : String = ""
    dynamic var sportClub_name : String = ""
    dynamic var language : String = ""
    dynamic var font_size : Int = 0
    dynamic var user_id : String = ""
    dynamic var sche_time_stamp : String = ""
    dynamic var user_time_stamp : String = ""
    dynamic var staff_id : String = ""
    dynamic var sche_inc_id : Int = 0
    dynamic var user_inc_id : Int = 0
}