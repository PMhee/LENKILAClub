//
//  Temp.swift
//  LenkilaClub
//
//  Created by Tanakorn on 8/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Temp:RLMObject{
    dynamic var type_of_table : String = ""
    dynamic var type : String = ""
    dynamic var schedule_id : String = ""
    dynamic var user_id : String = ""
}