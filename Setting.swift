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
    dynamic var passCode : String = "Geeksquadconsulting"
    dynamic var already_login : Bool = false
    dynamic var num_field : Int = 0
    dynamic var field_id : String = ""
    dynamic var field_name : String = ""
    dynamic var language : String = ""
    dynamic var font_size : Int = 0
}