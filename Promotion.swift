//
//  Promotion.swift
//  LenkilaClub
//
//  Created by Tanakorn on 8/14/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Promotion:RLMObject{
    dynamic var promotion_name : String = ""
    dynamic var promotion_type : String = ""
    dynamic var promotion_discount_price : Double = 0.0
    dynamic var promotion_diccount_percent : Double = 0.0
    dynamic var promotion_age : Int = 0
    dynamic var gender : String = ""
    dynamic var user_id : String = ""
}