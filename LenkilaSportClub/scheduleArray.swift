//
//  scheduleArray.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 6/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class scheduleArray:RLMRealm{
    dynamic var table : NSDictionary = [String:Schedule]()
}