//
//  Schedule.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 6/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Schedule:RLMObject{
    dynamic var type : String = ""
    dynamic var date : String = ""
    dynamic var time : String = ""
    dynamic var price : Int = 0
    dynamic var field : String = ""
    dynamic var rep : Int = 0
    dynamic var id : String  = ""
    dynamic var tag : String = ""
    dynamic var userID : String = ""
}