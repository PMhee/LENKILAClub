//
//  AddTableViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 6/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import CVCalendar
import SCLAlertView
import SystemConfiguration
import Alamofire
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class AddTableViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var field : String!
    var date : Foundation.Date!
    var time : String!
    var name : String!
    var price : String!
    var rep : String!
    var tel : String!
    var realPrice :Double!
    var pickedColor : String = "red"
    var type :String = "reserve"
    var realRep  = 0
    var x : CGFloat! = nil
    var y : CGFloat! = nil
    var enable_touch : Bool = false
    var not_found :Bool = false
    var edit_price : Bool = false
    var diff_hour : Double = 0.0
    var scheduleArray = [Schedule]()
    var edit : Bool = false
    var id : String = ""
    var in_keyboard : Bool = false
    var userArray = [User]()
    let ip_address = "http://128.199.227.19/"
    //var alamoFireManager : Alamofire.Manager!
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    @IBOutlet var tab_gesture: UITapGestureRecognizer!
    var checkedArray = [UIImageView]()
    @IBOutlet weak var tf_field: UITextField!
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_price: UITextField!
    //@IBOutlet weak var tf_repeat: UITextField!
    @IBOutlet weak var tf_tel: UITextField!
    @IBOutlet weak var tf_promotion: UITextField!
    @IBOutlet weak var line_field: UIView!
    @IBOutlet weak var line_date: UIView!
    @IBOutlet weak var line_name: UIView!
    //@IBOutlet weak var line_repeat: UIView!
    @IBOutlet weak var line_price: UIView!
    @IBOutlet weak var line_tel: UIView!
    @IBOutlet weak var line_promotion: UIView!
    @IBOutlet weak var line_time: UIView!
    @IBOutlet weak var btn_green: UIButton!
    @IBOutlet weak var btn_gray: UIButton!
    @IBOutlet weak var btn_dark_blue: UIButton!
    @IBOutlet weak var btn_blue: UIButton!
    @IBOutlet weak var btn_yellow: UIButton!
    @IBOutlet weak var btn_orange: UIButton!
    @IBOutlet weak var btn_pink: UIButton!
    @IBOutlet weak var btn_red: UIButton!
    @IBOutlet weak var img_checked_green: UIImageView!
    @IBOutlet weak var img_checked_gray: UIImageView!
    @IBOutlet weak var img_checked_dark_blue: UIImageView!
    @IBOutlet weak var img_checked_blue: UIImageView!
    @IBOutlet weak var img_checked_yellow: UIImageView!
    @IBOutlet weak var img_checked_orange: UIImageView!
    @IBOutlet weak var img_checked_pink: UIImageView!
    @IBOutlet weak var img_checked_red: UIImageView!
    @IBOutlet weak var tf_start_hour: UITextField!
    @IBOutlet weak var tf_start_min: UITextField!
    @IBOutlet weak var tf_end_hour: UITextField!
    @IBOutlet weak var tf_end_min: UITextField!
    var tab_trigger : Bool = false
    @IBOutlet weak var top_space: NSLayoutConstraint!
    @IBAction func tf_field_action(_ sender: UITextField) {
        line_field.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_date_action(_ sender: UITextField) {
        line_date.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_name_action(_ sender: UITextField) {
        line_name.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_price_action(_ sender: UITextField) {
        edit_price = !edit_price
        line_price.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
        top_space.constant -= 75
        sender.text = ""
    }
//    @IBAction func tf_repeat_action(sender: UITextField) {
//        line_repeat.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
//        top_space.constant -= 115
//        if self.realRep != nil {
//            sender.text = String(self.realRep)
//        }else{
//            sender.text = "1"
//        }
//    }
    @IBAction func tf_promotion_action(_ sender: UITextField) {
        line_promotion.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
        tf_promotion.text = ""
    }
    @IBAction func tf_tel_action(_ sender: UITextField) {
        line_tel.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
        //top_space.constant -= 55
    }
    @IBAction func tf_start_hour_action(_ sender: UITextField) {
        line_time.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_start_min_action(_ sender: UITextField) {
        line_time.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_end_hour_action(_ sender: UITextField) {
        line_time.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_end_min_action(_ sender: UITextField) {
        line_time.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    func trigger_tab(){
        var count = 0.0
        if !tab_trigger{
            //self.UserDetailTableView.userInteractionEnabled = false
            while(count <= 0.25){
                delay(count){
                    self.cons_vw_tab_width.constant += self.view.frame.width/13
                }
                count += 0.025
            }
        }else{
            //self.UserDetailTableView.userInteractionEnabled = true
            while(count <= 0.25){
                delay(count){
                    self.cons_vw_tab_width.constant -= self.view.frame.width/13
                }
                count += 0.025
            }
            
        }
        tab_trigger = !tab_trigger
    }
    
    @IBAction func tf_repeat_end(_ sender: UITextField) {
        top_space.constant += 115
        sender.text = sender.text!+" สัปดาห์"
        let range = sender.text!.range(of: " ")!
        let index = sender.text!.characters.distance(from: sender.text!.startIndex, to: range.lowerBound)
        self.realRep = Int(sender.text!.substring(with: (sender.text!.characters.index(sender.text!.startIndex, offsetBy: 0) ..< sender.text!.characters.index(sender.text!.startIndex, offsetBy: index))))!
    }
    @IBAction func tf_price_end(_ sender: UITextField) {
        top_space.constant += 75
        edit_price = !edit_price
        if sender.text! != "" {
            sender.text = sender.text!+" บาท"
        }else{
            sender.text = "1000 บาท"
        }
        let range = sender.text!.range(of: " ")!
        let index = sender.text!.characters.distance(from: sender.text!.startIndex, to: range.lowerBound)
        self.realPrice = Double(sender.text!.substring(with: (sender.text!.characters.index(sender.text!.startIndex, offsetBy: 0) ..< sender.text!.characters.index(sender.text!.startIndex, offsetBy: index))))
    }
    @IBAction func tf_tel_end(_ sender: AnyObject) {
        //top_space.constant += 55
        let users = User.allObjects()
        var found = false
        var user_id : String = ""
        var index:UInt = 0
        if users.count > 0 {
            for i in 0...users.count-1{
                let user : User = users[i] as! User
                if tf_tel.text! == user.contact{
                    user_id = user.id
                    found = true
                    index = i
                    break
                }
            }
        }
        if user_id != ""{
            tf_name.text = (users[index] as! User).nickName
        }
        
    }
    @IBAction func tf_promotion_end(_ sender: UITextField) {
        if sender.text == ""{
            tf_promotion.text = "ปกติ"
        }
    }
    @IBAction func btn_green_action(_ sender: UIButton) {
        self.pickedColor = "green"
        setButChecked(0)
    }
    @IBAction func btn_gray_action(_ sender: UIButton) {
        self.pickedColor = "gray"
        setButChecked(1)
    }
    @IBAction func btn_dark_blue_action(_ sender: UIButton) {
        self.pickedColor = "dark_blue"
        setButChecked(2)
    }
    @IBAction func btn_blue_action(_ sender: UIButton) {
        self.pickedColor = "blue"
        setButChecked(3)
    }
    @IBAction func btn_yellow_action(_ sender: UIButton) {
        self.pickedColor = "yellow"
        setButChecked(4)
    }
    @IBAction func btn_orange_action(_ sender: UIButton) {
        self.pickedColor = "orange"
        setButChecked(5)
    }
    @IBAction func btn_pink_action(_ sender: UIButton) {
        self.pickedColor = "pink"
        setButChecked(6)
    }
    @IBAction func btn_red_action(_ sender: UIButton) {
        self.pickedColor = "red"
        setButChecked(7)
    }
    
    func calculateTime(_ time:Bool){
        let a : String = self.time
        let range: Range<String.Index> = a.range(of: " ")!
        var index: Int = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let sHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< a.characters.index(a.startIndex, offsetBy: 2)))
        var sMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 3) ..< a.characters.index(a.startIndex, offsetBy: 5)))
        var eMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 11) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
        let eHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 8) ..< a.characters.index(a.startIndex, offsetBy: 10)))
        var startHour : Int = Int(sHour)!
        let startMin : Int = Int(sMin)!
        var endHour : Int = Int(eHour)!
        let endMin : Int  = Int(eMin)!
        if !time{
            if startMin == 0 {
                startHour -= 1
                sMin = "30"
            }else if startMin == 30 {
                sMin = "00"
            }
            if endMin == 0 {
                endHour -= 1
                eMin = "30"
            }else if endMin == 30 {
                eMin = "00"
            }
        }else{
            if startMin == 0 {
                sMin = "30"
            }else if startMin == 30 {
                sMin = "00"
                startHour += 1
            }
            if endMin == 0 {
                eMin = "30"
            }else if endMin == 30 {
                eMin = "00"
                endHour += 1
            }
        }
        self.time = String(startHour)+"."+sMin+" - "+String(endHour)+"."+eMin
    }
    @IBAction func btn_add_action(_ sender: AnyObject) {
        findDiffHour()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4 // seconds
        configuration.timeoutIntervalForResource = 4
        //self.alamoFireManager = Alamofire.Manager(configuration: configuration)
        var json = NSDictionary()
        let realm = RLMRealm.default()
        var schedule = Schedule()
        let sche = Schedule.allObjects()
        let setting = Setting.allObjects()
        if edit{
            for i in 0..<sche.count{
                let s = sche[i] as! Schedule
                if s.id == self.id{
                    schedule = s
                    break
                }
            }
            realm.beginWriteTransaction()
        }
        schedule.field = self.field
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        schedule.date = self.tf_date.text!
        schedule.time = self.tf_start_hour.text!+"."+self.tf_start_min.text!+" - "+self.tf_end_hour.text!+"."+self.tf_end_min.text!
        if edit_price{
            schedule.price = Double(self.tf_price.text!)! * diff_hour
        }else{
            schedule.price = self.realPrice * diff_hour
        }
        if self.scheduleArray.count == 0 {
            schedule.tag = 1
        }else{
            schedule.tag = self.scheduleArray[scheduleArray.count-1].tag+1
        }
        schedule.colorTag = self.pickedColor
        schedule.type = self.type
        if !edit{
            let setting = Setting.allObjects()
            let s = setting[0] as! Setting
            schedule.id = String(s.sche_inc_id)
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            s.sche_inc_id += 1
            try! realm.commitWriteTransaction()
            
        }
        schedule.paid_type = "cash"
        schedule.promotion = tf_promotion.text!
        schedule.sportClubID = (setting[0] as! Setting).sportClub_id
        schedule.staffID = (setting[0] as! Setting).staff_id
        schedule.sort_date = createSortDate(schedule.date, time: schedule.time)
        let range = self.rep.range(of: " ")!
        let index = self.rep.distance(from: self.rep.startIndex, to: range.lowerBound)
        //self.realRep = Int(self.tf_repeat.text!.substringWithRange(Range<String.Index>(start:self.tf_repeat.text!.startIndex.advancedBy(0), end: self.tf_repeat.text!.startIndex.advancedBy(index))))
        var temp = schedule.date
        if self.realRep >= 2 {
            self.realRep = self.realRep - 1
            for i in 0...self.realRep {
                var schedules = Schedule()
                let sche = Schedule.allObjects()
                if edit{
                    for i in 0..<sche.count{
                        let s = sche[i] as! Schedule
                        if s.id == self.id{
                            schedules = s
                            break
                        }
                    }
                    realm.beginWriteTransaction()
                }
                schedules.field = self.field
                let format = DateFormatter()
                format.dateStyle = DateFormatter.Style.full
                if schedules.date == "" {
                    schedules.date = temp
                }
                if i == 0 {
                }else{
                    let nextDay = format.date(from: schedules.date)?.addingTimeInterval(60*60*24*7)
                    schedules.date = format.string(from: nextDay!)
                }
                schedules.time = self.tf_start_hour.text!+"."+self.tf_start_min.text!+" - "+self.tf_end_hour.text!+"."+self.tf_end_min.text!
                if edit_price {
                    schedules.price = Double(self.tf_price.text!)! * diff_hour
                }else{
                    schedules.price = self.realPrice * diff_hour
                }
                if self.scheduleArray.count == 0 {
                    schedule.tag = 1
                }else{
                    schedules.tag = scheduleArray[scheduleArray.count-1].tag+1
                }
                schedules.colorTag = self.pickedColor
                schedules.type = self.type
                schedules.paid_type = "cash"
                schedules.promotion = tf_promotion.text!
                schedules.sportClubID = (setting[0] as! Setting).sportClub_id
                schedules.staffID = (setting[0] as! Setting).staff_id
                schedules.sort_date = createSortDate(schedules.date, time: schedules.time)
                if !edit{
                    let setting = Setting.allObjects()
                    let s = setting[0] as! Setting
                    schedules.id = String(s.sche_inc_id)
                    let realm = RLMRealm.default()
                    realm.beginWriteTransaction()
                    s.sche_inc_id += 1
                    try! realm.commitWriteTransaction()
                }
                let users = User.allObjects()
                var found = false
                if users.count > 0 {
                    for i in 0...users.count-1{
                        let user : User = users[i] as! User
                        if tf_tel.text! == user.contact{
                            schedules.userID = user.id
                            found = true
                            break
                        }
                    }
                }
                if found {
                    if !edit{
                        temp = schedules.date
                        realm.beginWriteTransaction()
                        realm.add(schedules)
                        try! realm.commitWriteTransaction()
//                        if self.isConnectedToNetwork(){
//                            let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedules.id)&type=reserve&date=\(schedules.date)&time=\(schedules.time)&price=\(schedules.price)&tag=\(schedules.tag)&userID=\(schedules.userID)&colorTag=\(schedules.colorTag)&paidType=\(schedules.paid_type)&alreadyPaid=\(schedules.already_paid)&sortDate=\(schedules.sort_date)&fieldID=\(schedules.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                            print(encode!)
//                            self.alamoFireManager.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                .validate()
//                                .responseString { response in
//                                    print("Success: \(response.result.isSuccess)")
//                                    print("Response String: \(response.result.value)")
//                                    
//                                    if !response.result.isSuccess{
//                                        //                                        let temp = Temp()
//                                        //                                        realm.beginWriteTransaction()
//                                        //                                        temp.type = "create"
//                                        //                                        temp.schedule_id = schedules.id
//                                        //                                        temp.type_of_table = "schedule"
//                                        //                                        realm.addObject(temp)
//                                        //                                        try! realm.commitWriteTransaction()
//                                    }
//                                }.responseJSON { response in
//                                    debugPrint(response.result.value)
//                                    if response.result.value == nil {
//                                        print("it's ")
//                                    }else{
//                                        json = response.result.value as! NSDictionary
//                                        realm.beginWriteTransaction()
//                                        let df = DateFormatter()
//                                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                        let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                        let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                        schedules.updated_at = update
//                                        schedules.created_at = create
//                                        let setting = Setting.allObjects()
//                                        let s = setting[0] as! Setting
//                                        s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                        try! realm.commitWriteTransaction()
//                                    }
//                            }
//                        }else{
                            print("ww")
                            let temp = Temp()
                            realm.beginWriteTransaction()
                            temp.type = "create"
                            temp.schedule_id = schedules.id
                            temp.type_of_table = "schedule"
                            realm.add(temp)
                            try! realm.commitWriteTransaction()
                        //}
                    }else{
                        try! realm.commitWriteTransaction()
//                        if self.isConnectedToNetwork(){
//                            let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedules.id)&type=reserve&date=\(schedules.date)&time=\(schedules.time)&price=\(schedules.price)&tag=\(schedules.tag)&userID=\(schedules.userID)&colorTag=\(schedules.colorTag)&paidType=\(schedules.paid_type)&alreadyPaid=\(schedules.already_paid)&sortDate=\(schedules.sort_date)&fieldID=\(schedules.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                            self.alamoFireManager.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                .validate()
//                                .responseString { response in
//                                    print("Success: \(response.result.isSuccess)")
//                                    print("Response String: \(response.result.value)")
//                                    if !response.result.isSuccess{
//                                        //                                        let temp = Temp()
//                                        //                                        realm.beginWriteTransaction()
//                                        //                                        temp.type = "update"
//                                        //                                        temp.type_of_table = "schedule"
//                                        //                                        temp.schedule_id = schedules.id
//                                        //                                        try! realm.commitWriteTransaction()
//                                    }
//                                }.responseJSON { response in
//                                    debugPrint(response.result.value)
//                                    if response.result.value == nil {
//                                        
//                                    }else{
//                                        realm.beginWriteTransaction()
//                                        json = response.result.value as! NSDictionary
//                                        let df = DateFormatter()
//                                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                        let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                        let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                        schedules.updated_at = update
//                                        schedules.created_at = create
//                                        let setting = Setting.allObjects()
//                                        let s = setting[0] as! Setting
//                                        s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                        try! realm.commitWriteTransaction()
//                                    }
//                                    
//                            }
//                        }else{
                            let temp = Temp()
                            realm.beginWriteTransaction()
                            temp.type = "update"
                            temp.type_of_table = "schedule"
                            temp.schedule_id = schedules.id
                            try! realm.commitWriteTransaction()
                        //}
                    }
                }else{
                    not_found = true
                    continue
                }
            }
            if not_found{
                try! realm.commitWriteTransaction()
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("เพิ่มสมาชิก", action: {
                    let realm = RLMRealm.default()
                    let users = User.allObjects()
                    let user = User()
                    if !self.edit{
                        let setting = Setting.allObjects()
                        let s = setting[0] as! Setting
                        user.id = String(s.user_inc_id)
                        let realm = RLMRealm.default()
                        realm.beginWriteTransaction()
                        s.user_inc_id += 1
                        try! realm.commitWriteTransaction()
                    }
                    user.nickName = self.tf_name.text!
                    user.contact = self.tf_tel.text!
                    realm.beginWriteTransaction()
                    if self.edit{}else{
                        realm.add(user)
                    }
//                    if self.isConnectedToNetwork(){
//                        print("User ID"+user.id)
//                        let ec = "\((setting[0] as! Setting).sportClub_id)&userID=\(user.id)&nickName=\(user.nickName)&telephone=\(user.contact)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                        self.alamoFireManager.request(.POST, "\(self.ip_address)User/create?sportClubID=\(ec!)")
//                            .validate()
//                            .responseString { response in
//                                print("Success: \(response.result.isSuccess)")
//                                print("Response String: \(response.result.value)")
//                                if !response.result.isSuccess{
//                                    //                                    let temp = Temp()
//                                    //                                    realm.beginWriteTransaction()
//                                    //                                    temp.type = "create"
//                                    //                                    temp.type_of_table = "user"
//                                    //                                    temp.user_id = user.id
//                                    //                                    realm.addObject(temp)
//                                    //                                    try! realm.commitWriteTransaction()
//                                }
//                            }.responseJSON { response in
//                                debugPrint(response.result.value)
//                                if response.result.value == nil {
//                                    
//                                }else{
//                                    realm.beginWriteTransaction()
//                                    json = response.result.value as! NSDictionary
//                                    let df = DateFormatter()
//                                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                    let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                    let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                    user.updated_at = update
//                                    user.created_at = create
//                                    let setting = Setting.allObjects()
//                                    let s = setting[0] as! Setting
//                                    s.user_time_stamp = json.value(forKey: "updated_at") as! String
//                                    try! realm.commitWriteTransaction()
//                                }
//                        }
//                        print("\(self.ip_address)User/create?sportClubID=\(ec!)")
//                    }else{
//                        let temp = Temp()
//                        print("ww")
//                        realm.beginWriteTransaction()
//                        temp.type = "create"
//                        temp.type_of_table = "user"
//                        temp.user_id = user.id
//                        realm.add(temp)
//                        try! realm.commitWriteTransaction()
                    //}
                    var schedule = Schedule()
                    let sche = Schedule.allObjects()
                    if self.edit{
                        for i in 0..<sche.count{
                            let s = sche[i] as! Schedule
                            if s.id == self.id{
                                schedule = s
                                break
                            }
                        }
                        realm.beginWriteTransaction()
                    }
                    schedule.field = self.field
                    let format = DateFormatter()
                    format.dateStyle = DateFormatter.Style.full
                    schedule.date = self.tf_date.text!
                    schedule.time = self.tf_start_hour.text!+"."+self.tf_start_min.text!+" - "+self.tf_end_hour.text!+"."+self.tf_end_min.text!
                    if !self.edit{
                        if self.edit_price{
                            schedule.price = Double(self.tf_price.text!)! * self.diff_hour
                        }else{
                            schedule.price = self.realPrice * self.diff_hour
                        }
                    }
                    if self.scheduleArray.count == 0 {
                        schedule.tag = 1
                    }else{
                        schedule.tag = self.scheduleArray[self.scheduleArray.count-1].tag+1
                    }
                    schedule.colorTag = self.pickedColor
                    schedule.type = self.type
                    schedule.paid_type = "cash"
                    schedule.promotion = self.tf_promotion.text!
                    schedule.sportClubID = (setting[0] as! Setting).sportClub_id
                    schedule.staffID = (setting[0] as! Setting).staff_id
                    schedule.sort_date = self.createSortDate(schedule.date, time: schedule.time)
                    if !self.edit{
                        let setting = Setting.allObjects()
                        let s = setting[0] as! Setting
                        schedule.id = String(s.sche_inc_id)
                        let realm = RLMRealm.default()
                        realm.beginWriteTransaction()
                        s.sche_inc_id += 1
                        try! realm.commitWriteTransaction()
                    }
                    let range = self.rep.range(of: " ")!
                    let index = self.rep.distance(from: self.rep.startIndex, to: range.lowerBound)
                    //self.realRep = Int(self.tf_repeat.text!.substringWithRange(Range<String.Index>(start:self.tf_repeat.text!.startIndex.advancedBy(0), end: self.tf_repeat.text!.startIndex.advancedBy(index))))
                    var temp = schedule.date
                    if self.realRep >= 2 {
                        self.realRep = self.realRep - 1
                        for i in 0...self.realRep {
                            var schedules = Schedule()
                            let sche = Schedule.allObjects()
                            if self.edit{
                                for i in 0..<sche.count{
                                    let s = sche[i] as! Schedule
                                    if s.id == self.id{
                                        schedules = s
                                        break
                                    }
                                }
                                realm.beginWriteTransaction()
                            }
                            schedules.field = self.field
                            let format = DateFormatter()
                            format.dateStyle = DateFormatter.Style.full
                            if schedules.date == "" {
                                schedules.date = temp
                            }
                            if i == 0 {
                            }else{
                                let nextDay = format.date(from: schedules.date)?.addingTimeInterval(60*60*24*7)
                                schedules.date = format.string(from: nextDay!)
                            }
                            schedules.time = self.tf_start_hour.text!+"."+self.tf_start_min.text!+" - "+self.tf_end_hour.text!+"."+self.tf_end_min.text!
                            if !self.edit{
                                if self.edit_price{
                                    schedules.price = Double(self.tf_price.text!)! * self.diff_hour
                                }else{
                                    schedules.price = self.realPrice * self.diff_hour
                                }
                            }
                            if self.scheduleArray.count == 0 {
                                schedule.tag = 1
                            }else{
                                schedules.tag = self.scheduleArray[self.scheduleArray.count-1].tag+1
                            }
                            schedules.colorTag = self.pickedColor
                            schedules.type = self.type
                            schedules.userID = user.id
                            schedules.paid_type = "cash"
                            schedules.promotion = self.tf_promotion.text!
                            schedules.sportClubID = (setting[0] as! Setting).sportClub_id
                            schedules.staffID = (setting[0] as! Setting).staff_id
                            schedules.sort_date = self.createSortDate(schedules.date, time: schedules.time)
                            if !self.edit{
                                let setting = Setting.allObjects()
                                let s = setting[0] as! Setting
                                schedules.id = String(s.sche_inc_id)
                                let realm = RLMRealm.default()
                                realm.beginWriteTransaction()
                                s.sche_inc_id += 1
                                try! realm.commitWriteTransaction()
                            }
                            temp = schedules.date
                            if self.edit{
                                try! realm.commitWriteTransaction()
//                                if self.isConnectedToNetwork(){
//                                    let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedules.id)&type=reserve&date=\(schedules.date)&time=\(schedules.time)&price=\(schedules.price)&tag=\(schedules.tag)&userID=\(schedules.userID)&colorTag=\(schedules.colorTag)&paidType=\(schedules.paid_type)&alreadyPaid=\(schedules.already_paid)&sortDate=\(schedules.sort_date)&fieldID=\(schedules.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                                    print(encode)
//                                    self.alamoFireManager.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                        .validate()
//                                        .responseString { response in
//                                            print("Success: \(response.result.isSuccess)")
//                                            print("Response String: \(response.result.value)")
//                                            if !response.result.isSuccess{
//                                                //                                                let temp = Temp()
//                                                //                                                realm.beginWriteTransaction()
//                                                //                                                temp.type = "update"
//                                                //                                                temp.type_of_table = "schedule"
//                                                //                                                temp.schedule_id = schedules.id
//                                                //                                                realm.addObject(temp)
//                                                //                                                try! realm.commitWriteTransaction()
//                                            }
//                                        }.responseJSON { response in
//                                            debugPrint(response.result.value)
//                                            if response.result.value == nil {
//                                                
//                                            }else{
//                                                realm.beginWriteTransaction()
//                                                json = response.result.value as! NSDictionary
//                                                let df = DateFormatter()
//                                                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                                let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                                let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                                schedules.updated_at = update
//                                                schedules.created_at = create
//                                                let setting = Setting.allObjects()
//                                                let s = setting[0] as! Setting
//                                                s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                                try! realm.commitWriteTransaction()
//                                            }
//                                    }
//                                }else{
                                    print("ww")
                                    let temp = Temp()
                                    realm.beginWriteTransaction()
                                    temp.type = "update"
                                    temp.type_of_table = "schedule"
                                    temp.schedule_id = schedules.id
                                    realm.add(temp)
                                    try! realm.commitWriteTransaction()
                                //}
                            }else{
                                realm.beginWriteTransaction()
                                realm.add(schedules)
                                try! realm.commitWriteTransaction()
//                                if self.isConnectedToNetwork(){
//                                    let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedules.id)&type=reserve&date=\(schedules.date)&time=\(schedules.time)&price=\(schedules.price)&tag=\(schedules.tag)&userID=\(schedules.userID)&colorTag=\(schedules.colorTag)&paidType=\(schedules.paid_type)&alreadyPaid=\(schedules.already_paid)&sortDate=\(schedules.sort_date)&fieldID=\(schedules.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                                    print(encode)
//                                    self.alamoFireManager.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                        .validate()
//                                        .responseString { response in
//                                            print("Success: \(response.result.isSuccess)")
//                                            print("Response String: \(response.result.value)")
//                                            if !response.result.isSuccess{
//                                                //                                            let temp = Temp()
//                                                //                                            realm.beginWriteTransaction()
//                                                //                                            temp.type = "create"
//                                                //                                            temp.type_of_table = "schedule"
//                                                //                                            temp.schedule_id = schedules.id
//                                                //                                            realm.addObject(temp)
//                                                //                                            try! realm.commitWriteTransaction()
//                                            }
//                                        }.responseJSON { response in
//                                            debugPrint(response.result.value)
//                                            if response.result.value == nil {
//                                                
//                                            }else{
//                                                json = response.result.value as! NSDictionary
//                                                let df = DateFormatter()
//                                                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                                let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                                let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                                realm.beginWriteTransaction()
//                                                schedules.updated_at = update
//                                                schedules.created_at = create
//                                                let setting = Setting.allObjects()
//                                                let s = setting[0] as! Setting
//                                                s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                                try! realm.commitWriteTransaction()
//                                            }
//                                    }
//                                }else{
                                    print("ww")
                                    let temp = Temp()
                                    realm.beginWriteTransaction()
                                    temp.type = "create"
                                    temp.type_of_table = "schedule"
                                    temp.schedule_id = schedules.id
                                    realm.add(temp)
                                    try! realm.commitWriteTransaction()
                                //}
                            }
                        }
                        self.performSegue(withIdentifier: "back_to_schedule", sender: self)
                    }
                })
                alert.addButton("ยกเลิก", action: {
                    self.not_found = false
                })
                alert.showWarning("เตือน", subTitle: "ไม่มีสมาชิกชื่อนี้อยู่ในข้อมูล")
            }else{
                self.performSegue(withIdentifier: "back_to_schedule", sender: self)
            }
        }else{
            let users = User.allObjects()
            var found = false
            if users.count > 0 {
                for i in 0...users.count-1{
                    let user : User = users[i] as! User
                    if tf_tel.text! == user.contact{
                        schedule.userID = user.id
                        found = true
                        continue
                    }
                }
            }
            if found {
                if edit{
                    try! realm.commitWriteTransaction()
//                    if self.isConnectedToNetwork(){
//                        let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedule.id)&type=reserve&date=\(schedule.date)&time=\(schedule.time)&price=\(schedule.price)&tag=\(schedule.tag)&userID=\(schedule.userID)&colorTag=\(schedule.colorTag)&paidType=\(schedule.paid_type)&alreadyPaid=\(schedule.already_paid)&sortDate=\(schedule.sort_date)&fieldID=\(schedule.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                        print(encode)
//                        self.alamoFireManager.request(.PUT, "\(ip_address)Schedule/update?sportClubID=\(encode!)")
//                            
//                            .validate()
//                            .responseString { response in
//                                print("Success: \(response.result.isSuccess)")
//                                print("Response String: \(response.result.value)")
//                                if !response.result.isSuccess{
//                                    
//                                }
//                            }.responseJSON { response in
//                                debugPrint(response.result.value)
//                                if response.result.value == nil {
//                                    //                                    let temp = Temp()
//                                    //                                    realm.beginWriteTransaction()
//                                    //                                    temp.type = "update"
//                                    //                                    temp.type_of_table = "schedule"
//                                    //                                    temp.schedule_id = schedule.id
//                                    //                                    realm.addObject(temp)
//                                    //                                    try! realm.commitWriteTransaction()
//                                }else{
//                                    realm.beginWriteTransaction()
//                                    json = response.result.value as! NSDictionary
//                                    let df = DateFormatter()
//                                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                    let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                    let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                    schedule.updated_at = update
//                                    schedule.created_at = create
//                                    let setting = Setting.allObjects()
//                                    let s = setting[0] as! Setting
//                                    s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                    try! realm.commitWriteTransaction()
//                                }
//                        }
//                    }else{
                        print("ww")
                        let temp = Temp()
                        realm.beginWriteTransaction()
                        temp.type = "update"
                        temp.type_of_table = "schedule"
                        temp.schedule_id = schedule.id
                        realm.add(temp)
                        try! realm.commitWriteTransaction()
                    //}
                }else{
                    realm.beginWriteTransaction()
                    realm.add(schedule)
                    try! realm.commitWriteTransaction()
//                    if self.isConnectedToNetwork(){
//                        let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedule.id)&type=reserve&date=\(schedule.date)&time=\(schedule.time)&price=\(schedule.price)&tag=\(schedule.tag)&userID=\(schedule.userID)&colorTag=\(schedule.colorTag)&paidType=\(schedule.paid_type)&alreadyPaid=\(schedule.already_paid)&sortDate=\(schedule.sort_date)&fieldID=\(schedule.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                        print(encode)
//                        self.alamoFireManager.request(.POST, "\(ip_address)Schedule/create?sportClubID=\(encode!)")
//                            
//                            .validate()
//                            .responseString { response in
//                                print("Success: \(response.result.isSuccess) Here")
//                                print("Response String: \(response.result.value)")
//                                print(response.result)
//                                if !response.result.isSuccess{
//                                }
//                            }.responseJSON { response in
//                                debugPrint(response.result.value)
//                                if response.result.value == nil {
//                                    print("hello")
//                                    //                                let temp = Temp()
//                                    //                                realm.beginWriteTransaction()
//                                    //                                temp.type = "create"
//                                    //                                temp.type_of_table = "schedule"
//                                    //                                temp.schedule_id = schedule.id
//                                    //                                realm.addObject(temp)
//                                    //                                try! realm.commitWriteTransaction()
//                                    
//                                }else{
//                                    json = response.result.value as! NSDictionary
//                                    print(json)
//                                    realm.beginWriteTransaction()
//                                    let df = DateFormatter()
//                                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                    let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                    let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                    schedule.updated_at = update
//                                    schedule.created_at = create
//                                    let setting = Setting.allObjects()
//                                    let s = setting[0] as! Setting
//                                    s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                    try! realm.commitWriteTransaction()
//                                }
//                        }
                   // }else{
                        print("ww")
                        let temp = Temp()
                        realm.beginWriteTransaction()
                        temp.type = "create"
                        temp.type_of_table = "schedule"
                        temp.schedule_id = schedule.id
                        realm.add(temp)
                        try! realm.commitWriteTransaction()
                    //}
                    
                }
                self.performSegue(withIdentifier: "back_to_schedule", sender: self)
            }else{
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("เพิ่มสมาชิก", action: {
                    let user = User()
                    let setting = Setting.allObjects()
                    let s = setting[0] as! Setting
                    user.id = String(s.user_inc_id)
                    let realm = RLMRealm.default()
                    realm.beginWriteTransaction()
                    s.user_inc_id += 1
                    try! realm.commitWriteTransaction()
                    user.nickName = self.tf_name.text!
                    user.contact = self.tf_tel.text!
                    if self.edit{
                        try! realm.commitWriteTransaction()
//                        if self.isConnectedToNetwork(){
//                            let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedule.id)&type=reserve&date=\(schedule.date)&time=\(schedule.time)&price=\(schedule.price)&tag=\(schedule.tag)&userID=\(schedule.userID)&colorTag=\(schedule.colorTag)&paidType=\(schedule.paid_type)&alreadyPaid=\(schedule.already_paid)&sortDate=\(schedule.sort_date)&fieldID=\(schedule.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                            print(encode)
//                            self.alamoFireManager.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                
//                                .validate()
//                                .responseString { response in
//                                    print("Success: \(response.result.isSuccess)")
//                                    print("Response String: \(response.result.value)")
//                                    if !response.result.isSuccess{
//                                        //                                        let temp = Temp()
//                                        //                                        realm.beginWriteTransaction()
//                                        //                                        temp.type = "update"
//                                        //                                        temp.type_of_table = "schedule"
//                                        //                                        temp.schedule_id = schedule.id
//                                        //                                        realm.addObject(temp)
//                                        //                                        try! realm.commitWriteTransaction()
//                                    }
//                                }.responseJSON { response in
//                                    debugPrint(response.result.value)
//                                    if response.result.value == nil {
//                                        
//                                    }else{
//                                        realm.beginWriteTransaction()
//                                        json = response.result.value as! NSDictionary
//                                        let df = DateFormatter()
//                                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                        let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                        let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                        schedule.updated_at = update
//                                        schedule.created_at = create
//                                        let setting = Setting.allObjects()
//                                        let s = setting[0] as! Setting
//                                        s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                        try! realm.commitWriteTransaction()
//                                    }
//                            }
//                        }else{
                            print("ww")
                            let temp = Temp()
                            realm.beginWriteTransaction()
                            temp.type = "update"
                            temp.type_of_table = "schedule"
                            temp.schedule_id = schedule.id
                            realm.add(temp)
                            try! realm.commitWriteTransaction()
                        //}
                    }else{
                        schedule.userID = user.id
                        realm.beginWriteTransaction()
                        realm.add(schedule)
                        realm.add(user)
                        try! realm.commitWriteTransaction()
//                        if self.isConnectedToNetwork(){
//                            let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedule.id)&type=reserve&date=\(schedule.date)&time=\(schedule.time)&price=\(schedule.price)&tag=\(schedule.tag)&userID=\(schedule.userID)&colorTag=\(schedule.colorTag)&paidType=\(schedule.paid_type)&alreadyPaid=\(schedule.already_paid)&sortDate=\(schedule.sort_date)&fieldID=\(schedule.field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                            print(encode)
//                            self.alamoFireManager.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                
//                                .validate()
//                                .responseString { response in
//                                    print("Success: \(response.result.isSuccess)")
//                                    print("Response String: \(response.result.value)")
//                                    if !response.result.isSuccess{
//                                    }
//                                }.responseJSON { response in
//                                    debugPrint(response.result.value)
//                                    if response.result.value == nil {
//                                        //                                    let temp = Temp()
//                                        //                                    realm.beginWriteTransaction()
//                                        //                                    temp.type = "create"
//                                        //                                    temp.type_of_table = "schedule"
//                                        //                                    temp.schedule_id = schedule.id
//                                        //                                    realm.addObject(temp)
//                                        //                                    temp.type = "create"
//                                        //                                    temp.type_of_table = "user"
//                                        //                                    temp.user_id = user.id
//                                        //                                    realm.addObject(temp)
//                                        //                                    try! realm.commitWriteTransaction()
//                                        
//                                    }else{
//                                        json = response.result.value as! NSDictionary
//                                        realm.beginWriteTransaction()
//                                        let df = DateFormatter()
//                                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                        print(json.value(forKey: "updated_at") as! String)
//                                        let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                        let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                        schedule.updated_at = update
//                                        schedule.created_at = create
//                                        let setting = Setting.allObjects()
//                                        let s = setting[0] as! Setting
//                                        s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                        try! realm.commitWriteTransaction()
//                                    }
//                            }
//                            print("User ID"+user.id)
//                            let ec = "\((setting[0] as! Setting).sportClub_id)&userID=\(user.id)&nickName=\(user.nickName)&telephone=\(user.contact)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                            self.alamoFireManager.request(.POST, "\(self.ip_address)User/create?sportClubID=\(ec!)")
//                                .validate()
//                                .responseString { response in
//                                    print("Success: \(response.result.isSuccess)")
//                                    print("Response String: \(response.result.value)")
//                                    if !response.result.isSuccess{
//                                        //                                    let temp = Temp()
//                                        //                                    realm.beginWriteTransaction()
//                                        //                                    temp.type = "create"
//                                        //                                    temp.type_of_table = "user"
//                                        //                                    temp.user_id = user.id
//                                        //                                    realm.addObject(temp)
//                                        //                                    try! realm.commitWriteTransaction()
//                                    }
//                                }.responseJSON { response in
//                                    debugPrint(response.result.value)
//                                    if response.result.value == nil {
//                                        
//                                    }else{
//                                        json = response.result.value as! NSDictionary
//                                        realm.beginWriteTransaction()
//                                        let df = DateFormatter()
//                                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                        let update = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                        let create = df.date(from: json.value(forKey: "created_at") as! String)!
//                                        user.updated_at = update
//                                        user.created_at = create
//                                        let setting = Setting.allObjects()
//                                        let s = setting[0] as! Setting
//                                        s.user_time_stamp = json.value(forKey: "updated_at") as! String
//                                        try! realm.commitWriteTransaction()
//                                    }
//                            }
//                            print("\(self.ip_address)User/create?sportClubID=\(ec!)")
//                        }else{
                            print("ww")
                            let temp = Temp()
                            realm.beginWriteTransaction()
                            temp.type = "create"
                            temp.type_of_table = "schedule"
                            temp.schedule_id = schedule.id
                            realm.add(temp)
                            try! realm.commitWriteTransaction()
                            realm.beginWriteTransaction()
                            let t = Temp()
                            t.type = "create"
                            t.type_of_table = "user"
                            t.user_id = user.id
                            realm.add(t)
                            try! realm.commitWriteTransaction()
                        //}
                    }
                    self.performSegue(withIdentifier: "back_to_schedule", sender: self)
                })
                alert.addButton("ยกเลิก", action: {
                    
                })
                alert.showWarning("เตือน", subTitle: "ไม่มีสมาชิกชื่อนี้อยู่ในข้อมูล")
            }
        }
    }
    @IBAction func btn_cancel_action(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "back_to_schedule", sender: self)
    }
    
    func setButChecked(_ checked:Int){
        for i in 0...checkedArray.count-1{
            if i != checked{
                checkedArray[i].isHidden = true
            }else{
                checkedArray[i].isHidden = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkedArray += [img_checked_green,img_checked_gray,img_checked_dark_blue,img_checked_blue,img_checked_yellow,img_checked_orange,img_checked_pink,img_checked_red]
        genButton()
        genDelegate()
        genTextField()
        tab_gesture.delegate = self
        self.view.addGestureRecognizer(tab_gesture)
        let attr = NSDictionary(object: UIFont(name: "ThaiSansLite", size: 17.0)!, forKey: NSFontAttributeName as NSCopying)
        if edit{
            tf_name.text = self.name
        }else{
            tf_tel.becomeFirstResponder()
        }
        let schedule = Schedule.allObjects()
        for i in 0..<schedule.count{
            scheduleArray.append(schedule[i] as! Schedule)
        }
        let user = User.allObjects()
        for i in 0..<user.count{
            userArray.append(user[i] as! User)
        }
        if edit{
            tf_name.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //top_space.constant -= 55
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if tab_trigger {
            x = touch.location(in: self.view).x
            y = touch.location(in: self.view).y
            if x > self.view.frame.width * 11 / 13 {
                enable_touch = !enable_touch
            }
            return true
        }else if in_keyboard{
            tf_field.resignFirstResponder()
            tf_date.resignFirstResponder()
            tf_start_hour.resignFirstResponder()
            tf_start_min.resignFirstResponder()
            tf_end_hour.resignFirstResponder()
            tf_end_min.resignFirstResponder()
            tf_name.resignFirstResponder()
            tf_price.resignFirstResponder()
            //tf_repeat.resignFirstResponder()
            tf_tel.resignFirstResponder()
            tf_promotion.resignFirstResponder()
            line_time.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            line_field.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            line_date.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            line_name.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            line_price.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            //line_repeat.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            line_tel.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            line_promotion.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
            in_keyboard = false
            return true
        }else{
            return false
        }
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if enable_touch {
            self.trigger_tab()
            enable_touch = !enable_touch
            return true
        }else{
            return false
        }
    }
    
    func genDelegate(){
        tf_field.delegate = self
        tf_date.delegate = self
        tf_start_hour.delegate = self
        tf_start_min.delegate = self
        tf_end_hour.delegate = self
        tf_end_min.delegate = self
        tf_name.delegate = self
        tf_price.delegate = self
       // tf_repeat.delegate = self
        tf_tel.delegate = self
        tf_promotion.delegate = self
        tf_start_hour.keyboardType = UIKeyboardType.numberPad
        tf_start_min.keyboardType = UIKeyboardType.numberPad
        tf_end_hour.keyboardType = UIKeyboardType.numberPad
        tf_end_min.keyboardType = UIKeyboardType.numberPad
        tf_price.keyboardType = UIKeyboardType.numberPad
       // tf_repeat.keyboardType = UIKeyboardType.NumberPad
        tf_tel.keyboardType = UIKeyboardType.numberPad
    }
    func genTextField(){
        tf_field.text = self.field
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        tf_date.text = format.string(from: self.date)
        var a : String = self.time
        var range: Range<String.Index> = a.range(of: ".")!
        var index: Int = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let startHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< a.characters.index(a.startIndex, offsetBy: index)))
        range = a.range(of: " ")!
        let index1 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let startMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index+1) ..< (a.characters.index(a.startIndex, offsetBy: index1))))
        a = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index1+3) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
        range = a.range(of: ".")!
        let index2 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let endHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< (a.characters.index(a.startIndex, offsetBy: index2))))
        let endMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index2+1) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
        tf_start_hour.text = startHour
        tf_start_min.text = startMin
        tf_end_hour.text = endHour
        tf_end_min.text = endMin
        //tf_repeat.text = self.rep
        if edit{
            self.findDiffHour()
            var io : String = self.price
            let ran: Range<String.Index> = io.range(of: " ")!
            let ind: Int = io.characters.distance(from: io.startIndex, to: ran.lowerBound)
            io = io.substring(with: (io.characters.index(io.startIndex, offsetBy: 0) ..< io.characters.index(io.startIndex, offsetBy: ind)))
            print(io)
            tf_price.text = String(Double(io)! / self.diff_hour)
        }else{
            tf_price.text = self.price
        }
        tf_tel.text = self.tel
        tf_promotion.text = "ปกติ"
        range = self.price.range(of: " ")!
        index = self.price.distance(from: self.price.startIndex, to: range.lowerBound)
        self.realPrice = Double(self.price.substring(with: (self.price.index(self.price.startIndex, offsetBy: 0) ..< self.price.index(self.price.startIndex, offsetBy: index))))
        range = self.rep.range(of: " ")!
        index = self.rep.distance(from: self.rep.startIndex, to: range.lowerBound)
       // self.realRep = Int(self.tf_repeat.text!.substringWithRange(Range<String.Index>(start:self.tf_repeat.text!.startIndex.advancedBy(0), end: self.tf_repeat.text!.startIndex.advancedBy(index))))
    }
    func genButton(){
        btn_red.layer.cornerRadius = 5
        btn_blue.layer.cornerRadius = 5
        btn_gray.layer.cornerRadius = 5
        btn_pink.layer.cornerRadius = 5
        btn_green.layer.cornerRadius = 5
        btn_orange.layer.cornerRadius = 5
        btn_yellow.layer.cornerRadius = 5
        btn_dark_blue.layer.cornerRadius = 5
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        in_keyboard = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        line_time.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_field.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_date.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_name.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_price.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
       //line_repeat.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_tel.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_promotion.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        textField.resignFirstResponder()
        in_keyboard = false
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back_to_schedule" {
            if let des = segue.destination as? ScheduleViewController {
                let format = DateFormatter()
                format.dateStyle = DateFormatter.Style.full
                des.date = format.string(from: self.date)
                des.firstTime = true
            }
        }
    }
    func findDiffHour(){
        var diff_hour = Double(tf_end_hour.text!)! - Double(tf_start_hour.text!)!
        diff_hour += (Double(tf_end_min.text!)!-Double(tf_start_min.text!)!)/60
        self.diff_hour = diff_hour
    }
    func createSortDate(_ date:String,time:String)->Int{
        var time = time
        let dateFormatt = DateFormatter()
        dateFormatt.dateStyle = DateFormatter.Style.full
        dateFormatt.date(from: date)
        let formatt = DateFormatter()
        formatt.dateStyle = DateFormatter.Style.short
        var d = formatt.string(from: dateFormatt.date(from: date)!)
        var range = d.range(of: "/")!
        var index = d.characters.distance(from: d.startIndex, to: range.lowerBound)
        var month = d.substring(with: (d.characters.index(d.startIndex, offsetBy: 0) ..< d.characters.index(d.startIndex, offsetBy: index)))
        d = d.substring(with: (d.characters.index(d.startIndex, offsetBy: index+1) ..< d.characters.index(d.endIndex, offsetBy: 0)))
        range = d.range(of: "/")!
        index = d.characters.distance(from: d.startIndex, to: range.lowerBound)
        if month.characters.count == 1 {
            month = "0"+month
        }
        var day = d.substring(with: (d.characters.index(d.startIndex, offsetBy: 0) ..< d.characters.index(d.startIndex, offsetBy: index)))
        if day.characters.count == 1 {
            day = "0"+day
        }
        var year = d.substring(with: (d.characters.index(d.startIndex, offsetBy: index+1) ..< d.characters.index(d.endIndex, offsetBy: 0)))
        if year.characters.count > 4 {
            let range: Range<String.Index> = year.range(of: " ")!
            let index: Int = year.characters.distance(from: year.startIndex, to: range.lowerBound)
            year = year.substring(with: (year.characters.index(year.startIndex, offsetBy: 0) ..< year.characters.index(year.startIndex, offsetBy: index)))
        }
        range = time.range(of: ".")!
        index = time.characters.distance(from: time.startIndex, to: range.lowerBound)
        var startHour = time.substring(with: (time.characters.index(time.startIndex, offsetBy: 0) ..< time.characters.index(time.startIndex, offsetBy: index)))
        if startHour.characters.count == 1 {
            startHour = "0"+startHour
        }
        time = time.substring(with: (time.characters.index(time.startIndex, offsetBy: index+1) ..< time.characters.index(time.endIndex, offsetBy: 0)))
        range = time.range(of: " ")!
        index = time.characters.distance(from: time.startIndex, to: range.lowerBound)
        let startMin = time.substring(with: (time.characters.index(time.startIndex, offsetBy: 0) ..< time.characters.index(time.startIndex, offsetBy: index)))
        return Int(year+month+day+startHour+startMin)!
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
//    func isConnectedToNetwork() -> Bool {
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        return (isReachable && !needsConnection)
//    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
