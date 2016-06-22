//
//  FreqPlay.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/22/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class FreqPlay:RLMObject{
    dynamic var userID : String = ""
    dynamic var freq_play : String = ""
    dynamic var cal_freq_play : String = ""
    dynamic var day : String = ""
}