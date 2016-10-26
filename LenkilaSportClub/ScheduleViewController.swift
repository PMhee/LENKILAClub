//
//  ScheduleViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
import Alamofire
import SystemConfiguration
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

class ScheduleViewController: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate {
    //    @IBOutlet weak var view_time: UIView!
    //    @IBOutlet weak var scrollView_table: UIScrollView!
    //    @IBOutlet weak var scrollView_page: UIScrollView!
    //    @IBOutlet weak var cons_top_view: NSLayoutConstraint!
    //    @IBOutlet weak var cons_lead_view: NSLayoutConstraint!
    //    var changeHeight : CGFloat!
    //    var changeWidth: CGFloat!
    var del_slot:Int! = nil
    var already_show = false
    @IBOutlet weak var problem_view: UIView!
    @IBOutlet weak var vw_peak: UIView!
    let api = API()
    var tag : Int = 0
    var temp_tag : Int = 0
    var drag_top : Bool = false
    var cut_slot = [CGFloat]()
    var temp_h : Int = 0
    var real_date : String = ""
    var download_done = false
    var schedule_update = false
    var user_update = false
    let ip_address = "http://128.199.227.19/"
    @IBOutlet var long_gesture: UILongPressGestureRecognizer!
    @IBOutlet weak var vw_tab: UIView!
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    @IBOutlet weak var btn_date: UIButton!
    var enable_create_table : Bool = false
    var create_table : Bool = false
    var schedualArray = [Schedule]()
    var userArray = [String:User]()
    var user_array = [User]()
    var keepTag = [Int]()
    var slot = [String?]()
    var firstTime : Bool = false
    let tableColor : NSDictionary = ["green":UIColor(red:122/255,green:190/255,blue:139/255,alpha:1.0),"gray":UIColor(red:122/255,green:118/255,blue:119/255,alpha:1.0),"dark_blue":UIColor(red:84/255,green:110/255,blue:122/255,alpha:1.0),"blue":UIColor(red:16/255,green:118/255,blue:152/255,alpha:1.0),"yellow":UIColor(red:252/255,green:221/255,blue:121/255,alpha:1.0),"orange":UIColor(red:231/255,green:158/255,blue:63/255,alpha:1.0),"pink":UIColor(red:205/255,green:122/255,blue:121/255,alpha:1.0),"red":UIColor(red:232/255,green:81/255,blue:83/255,alpha:1.0)]
    
    var f : UIView! = nil
    var x : CGFloat! = nil
    var y : CGFloat! = nil
    var field_num = 4
    var hh  :CGFloat = 0.0
    var field : String!
    var date : String!
    var time : String!
    var name : String!
    var price : String!
    var rep : String!
    var today = Foundation.Date()
    var tab_trigger : Bool = false
    var enable_touch : Bool = false
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBAction func btn_tab_action(_ sender: UIButton) {
        trigger_tab()
        enable_touch = true
    }
    @IBAction func btn_date_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "popOver", sender: self)
    }
    @IBAction func long_press(_ sender: UILongPressGestureRecognizer) {
        switch  sender.state {
        case .ended:
            print("")
        default:
            if findSlotPosition(self.x, y: self.y) && !already_show{
                
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance:appearance)
                alert.addButton("เสร็จสิ้น",action:{
                    self.already_show = false
                })
                if !already_show{
                    alert.showWarning("เตือน", subTitle: "ไม่พบตารางที่จะลบ",duration: 1.5)
                }
            }else{
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance:appearance)
                alert.addButton("ใช่", action: {
                    self.performSegue(withIdentifier: "edit_table", sender: self)
                })
                alert.addButton("ไม่", action: {
                    self.already_show = false
                })
                alert.addButton("ลบตาราง", action: {
                    for i in 0..<self.schedualArray.count {
                        if i == Int(self.slot[self.del_slot]!) {
                            let id = self.schedualArray[i].id
                            let realm = RLMRealm.default()
                            realm.beginWriteTransaction()
                            realm.delete(self.schedualArray[i])
                            try! realm.commitWriteTransaction()
                            self.schedualArray.remove(at: i)
                            self.clearTable()
                            self.genScheduleOnTable()
                            self.already_show = false
//                            if self.isConnectedToNetwork(){
//                                let setting = Setting.allObjects()
//                                let encode = "\((setting[0] as! Setting).sportClub_id)/\((setting[0] as! Setting).staff_id)/\(id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                                print("\(self.ip_address)Schedule/delete/sportClubID=\(encode!)")
//                                Alamofire.request(.DELETE, "\(self.ip_address)Schedule/delete/\(encode!)")
//                                    .responseString { response in
//                                        print("Success: \(response.result.isSuccess)")
//                                        //print("Response String: \(response.result.value)")
//                                        if response.result.isSuccess{
//                                        }
//                                        
//                                    }
//                                    .responseJSON { response in
//                                        debugPrint(response.result.value)
//                                }
//                            }else{
//                                let realm = RLMRealm.default()
//                                realm.beginWriteTransaction()
//                                let temp = Temp()
//                                realm.beginWriteTransaction()
//                                temp.type = "delete"
//                                temp.schedule_id = id
//                                temp.type_of_table = "schedule"
//                                realm.add(temp)
//                                try! realm.commitWriteTransaction()
                           // }
                            
                        }
                    }
                })
                if !already_show{
                    alert.showWarning("เตือน", subTitle: "ต้องการจะแก้ไขหรือไม่")
                }
                self.already_show = true
            }
            
        }
        
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
    @IBAction func btn_left_action(_ sender: UIButton) {
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        btn_date.setTitle(format.string(from: format.date(from: (btn_date.titleLabel?.text)!)!.addingTimeInterval(-60*60*24)), for: UIControlState())
        real_date = format.string(from: (format.date(from: real_date)?.addingTimeInterval(-60*60*24))!)
        //today = today.dateByAddingTimeInterval(60*60*24)
        clearTable()
        self.genScheduleOnTable()
    }
    @IBAction func btn_today_action(_ sender: UIButton) {
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        btn_date.setTitle(format.string(from: Foundation.Date()), for: UIControlState())
        real_date = format.string(from: Foundation.Date())
        clearTable()
        self.genScheduleOnTable()
    }
    @IBAction func btn_right_action(_ sender: UIButton) {
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        btn_date.setTitle(format.string(from: format.date(from: (btn_date.titleLabel?.text)!)!.addingTimeInterval(60*60*24)), for: UIControlState())
        real_date = format.string(from: (format.date(from: real_date)?.addingTimeInterval(60*60*24))!)
        //today = today.dateByAddingTimeInterval(60*60*24)
        clearTable()
        self.genScheduleOnTable()
    }
    override func viewDidLoad() {
//        if isConnectedToNetwork(){
//            super.viewDidLoad()
//            var json = NSArray()
//            var json_user = NSArray()
//            let setting = Setting.allObjects()
//            var set = Setting()
//            let sche_tt = (setting[0] as! Setting).sche_time_stamp
//            let user_tt = (setting[0] as! Setting).user_time_stamp
//            var encode = "\((setting[0] as! Setting).sportClub_id)/\(sche_tt)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//            Alamofire.request(.GET, "\(ip_address)Schedule/lastUpdate/"+encode!)
//                .validate()
//                .responseString { response in
//                    print("Success: \(response.result.isSuccess)")
//                    print("Response String: \(response.result.value)")
//                }.responseJSON { response in
//                    debugPrint(response.result.value)
//                    if response.result.value == nil {
//                        
//                    }else{
//                        json = response.result.value as! NSArray
//                    }
//            }
//            encode = "\((setting[0] as! Setting).sportClub_id)/\(user_tt)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//            Alamofire.request(.GET, "\(ip_address)Schedule/lastUpdate/"+encode!)
//            Alamofire.request(.GET, "\(ip_address)User/lastUpdate/"+encode!)
//                .validate()
//                .responseString { response in
//                    print("Success: \(response.result.isSuccess)")
//                    print("Response String: \(response.result.value)")
//                }.responseJSON { response in
//                    debugPrint(response.result.value)
//                    if response.result.value == nil {
//                        
//                    }else{
//                        json_user = response.result.value as! NSArray
//                    }
//            }
//            // do some task
//            var maxU = 0
//            var maxS = 0
//            self.delay(2){
//                print("JSON"+String(json.count)+String(json_user.count))
//                if json_user.count > 0 {
//                    let realm = RLMRealm.default()
//                    realm.beginWriteTransaction()
//                    let s = setting[0] as! Setting
//                    s.user_time_stamp = (json[0] as AnyObject).value(forKey: "updated_at") as! String
//                    try! realm.commitWriteTransaction()
//                    self.user_update = true
//                    for i in 0..<json_user.count{
//                        let realm = RLMRealm.default()
//                        realm.beginWriteTransaction()
//                        let user =  User()
//                        user.id = ((json_user[i] as AnyObject).value(forKey: "userID") as! NSNumber).stringValue
//                        user.name = ((json_user[i] as AnyObject).value(forKey: "firstName") as! String)+((json_user[i] as AnyObject).value(forKey: "lastName") as! String)
//                        user.nickName = (json_user[i] as AnyObject).value(forKey: "nickName") as! String
//                        user.gender = (json_user[i] as AnyObject).value(forKey: "gender") as! String
//                        user.age = ((json_user[i] as AnyObject).value(forKey: "age") as! NSNumber).intValue
//                        user.workPlace = (json_user[i] as AnyObject).value(forKey: "workplace") as! String
//                        user.playCount = ((json_user[i] as AnyObject).value(forKey: "playCount") as! NSNumber).intValue
//                        user.contact = (json_user[i] as AnyObject).value(forKey: "telephone") as! String
//                        user.price = ((json_user[i] as AnyObject).value(forKey: "discountPercent") as! NSNumber).intValue
//                        user.freqPlay = (json_user[i] as AnyObject).value(forKey: "freqPlay") as! String
//                        let df = DateFormatter()
//                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        user.updated_at = df.date(from: (json_user[i] as AnyObject).value(forKey: "updated_at") as! String)!
//                        user.created_at = df.date(from: (json_user[i] as AnyObject).value(forKey: "created_at") as! String)!
//                        set = setting[0] as! Setting
//                        set.user_time_stamp = (json_user[i] as AnyObject).value(forKey: "updated_at") as! String
//                        if Int(user.id) > maxU {
//                            maxU = Int(user.id)!
//                        }
//                        let users = User.allObjects()
//                        if Int(user.id) < set.user_inc_id {
//                            for i in 0..<users.count{
//                                let u = users[i] as! User
//                                if u.id == user.id{
//                                    u.id = user.id
//                                    u.name = user.name
//                                    u.nickName = user.nickName
//                                    u.gender = user.gender
//                                    u.age = user.age
//                                    u.workPlace = user.workPlace
//                                    u.playCount = user.playCount
//                                    u.contact = user.contact
//                                    u.price = user.price
//                                    u.freqPlay = user.freqPlay
//                                }
//                            }
//                            try! realm.commitWriteTransaction()
//                        }else{
//                            realm.add(user)
//                            try! realm.commitWriteTransaction()
//                        }
//                    }
//                }
//                if json.count > 0 {
//                    let realm = RLMRealm.default()
//                    realm.beginWriteTransaction()
//                    let s = setting[0] as! Setting
//                    s.sche_time_stamp = (json[0] as AnyObject).value(forKey: "updated_at") as! String
//                    try! realm.commitWriteTransaction()
//                    self.schedule_update = true
//                    for i in 0..<json.count{
//                        let realm = RLMRealm.default()
//                        realm.beginWriteTransaction()
//                        let schedule = Schedule()
//                        schedule.id = ((json[i] as AnyObject).value(forKey: "scheduleID") as! NSNumber).stringValue
//                        schedule.type = (json[i] as AnyObject).value(forKey: "type") as! String
//                        schedule.date = (json[i] as AnyObject).value(forKey: "date") as! String
//                        schedule.time = (json[i] as AnyObject).value(forKey: "time") as! String
//                        schedule.price = ((json[i] as AnyObject).value(forKey: "price") as! NSNumber).doubleValue
//                        schedule.field = ((json[i] as AnyObject).value(forKey: "fieldID") as! NSNumber).stringValue
//                        schedule.tag = ((json[i] as AnyObject).value(forKey: "tag") as! NSNumber).intValue
//                        schedule.userID = ((json[i] as AnyObject).value(forKey: "userID") as! NSNumber).stringValue
//                        schedule.colorTag = (json[i] as AnyObject).value(forKey: "colorTag") as! String
//                        schedule.paid_type = (json[i] as AnyObject).value(forKey: "paidType") as! String
//                        schedule.already_paid = (json[i] as AnyObject).value(forKey: "alreadyPaid") as! Bool
//                        schedule.sort_date = ((json[i] as AnyObject).value(forKey: "sortDate") as! NSNumber).intValue
//                        schedule.sportClubID = ((json[i] as AnyObject).value(forKey: "sportClubID") as! NSNumber).stringValue
//                        schedule.staffID = ((json[i] as AnyObject).value(forKey: "staffID") as! NSNumber).stringValue
//                        let df = DateFormatter()
//                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        schedule.updated_at = df.date(from: (json[i] as AnyObject).value(forKey: "updated_at") as! String)!
//                        schedule.created_at = df.date(from: (json[i] as AnyObject).value(forKey: "created_at") as! String)!
//                        set = setting[0] as! Setting
//                        if Int(schedule.id) > maxS {
//                            maxS = Int(schedule.id)!
//                        }
//                        set.sche_time_stamp = (json[i] as AnyObject).value(forKey: "updated_at") as! String
//                        let schedules = Schedule.allObjects()
//                        if Int(schedule.id) < set.sche_inc_id{
//                            for i in 0..<schedules.count{
//                                let s = schedules[i] as! Schedule
//                                if s.id == schedule.id{
//                                    s.id = schedule.id
//                                    s.type = schedule.type
//                                    s.date = schedule.date
//                                    s.time = schedule.time
//                                    s.price = schedule.price
//                                    s.field = schedule.field
//                                    s.tag = schedule.tag
//                                    s.userID = schedule.userID
//                                    s.colorTag = schedule.colorTag
//                                    s.paid_type = schedule.paid_type
//                                    s.already_paid = schedule.already_paid
//                                    s.sort_date = schedule.sort_date
//                                    s.sportClubID = schedule.sportClubID
//                                    s.staffID = schedule.staffID
//                                    break
//                                }
//                            }
//                            try! realm.commitWriteTransaction()
//                        }else{
//                            realm.add(schedule)
//                            try! realm.commitWriteTransaction()
//                        }
//                    }
//                    let appearance = SCLAlertView.SCLAppearance(
//                        kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
//                        kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
//                        kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
//                        showCloseButton: false
//                    )
//                    let alert = SCLAlertView(appearance:appearance)
//                    alert.showInfo("อัพเดทข้อมูล", subTitle: "อัพเดทข้อมูลเรียบร้อยแล้ว",duration:2.0)
//                    
//                }
//                let realm = RLMRealm.default()
//                realm.beginWriteTransaction()
//                let s = setting[0] as! Setting
//                if s.sche_inc_id < maxS {
//                    s.sche_inc_id = maxS+1
//                }
//                if s.user_inc_id < maxU {
//                    s.user_inc_id = maxU+1
//                }
//                try! realm.commitWriteTransaction()
//            }
//            
//        }
        //        Alamofire.request(.POST, "http://192.168.1.35:8000/Schedule/delete/1/1/2")
        //            .validate()
        //            .responseString { response in
        //                print("Success: \(response.result.isSuccess)")
        //                print("Response String: \(response.result.value)")
        //        }
        //        Alamofire.request(.GET, "http://192.168.1.35:8000/Schedule/get/1/1/2")
        //            .validate()
        //            .responseString { response in
        //                print("Success: \(response.result.isSuccess)")
        //                print("Response String: \(response.result.value)")
        //        }
        //        Alamofire.request(.POST, "http://192.168.1.35:8000/Field/create?sportClubID=1&fieldID=6&fieldType=football&name=footballArena&height=13&width=13")
        //                    .validate()
        //                    .responseString { response in
        //                        print("Success: \(response.result.isSuccess)")
        //                        print("Response String: \(response.result.value)")
        //                }
        //        Alamofire.request(.POST, "http://192.168.1.35:8000/Setting/update?sportClubID=1&numField=4&language=en&fontSize=25&staffID=1")
        //            .validate()
        //            .responseString { response in
        //                print("Success: \(response.result.isSuccess)")
        //                print("Response String: \(response.result.value)")
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let setting = Setting.allObjects()
        let s = setting[0] as! Setting
        if s.num_field == 0 {
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            s.num_field = 4
            try! realm.commitWriteTransaction()
        }
        self.field_num = s.num_field
        if self.date != nil {
            btn_date.setTitle(self.date, for: UIControlState())
            real_date = date
        }else{
            let format = DateFormatter()
            format.dateStyle = DateFormatter.Style.full
            btn_date.setTitle(format.string(from: Foundation.Date()), for: UIControlState())
            real_date = (btn_date.titleLabel?.text!)!
        }
        tapGesture.delegate = self
        long_gesture.delegate = self
        long_gesture = UILongPressGestureRecognizer(target: self, action: #selector(ScheduleViewController.long_press(_:)))
        long_gesture.minimumPressDuration = 1
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ScheduleViewController.drag(_:)))
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(long_gesture)
        btn_today.layer.cornerRadius = 15
        self.genScheduleOnTable()
        self.genTableField()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let sche = Schedule.allObjects()
        let users = User.allObjects()
        if sche.count > 0 {
            for i in 0...sche.count-1{
                self.schedualArray.append(sche[i] as! Schedule)
            }
        }
        if users.count > 0 {
            for i in 0...users.count-1{
                self.userArray[(users[i] as AnyObject).value(forKey: "id") as! String] = users[i] as! User
                self.user_array.append(users[i] as! User)
            }
        }
        delay(2){
            if self.schedule_update{
                let sche = Schedule.allObjects()
                
                
                if sche.count > 0 {
                    for i in 0...sche.count-1{
                        self.schedualArray.append(sche[i] as! Schedule)
                    }
                }
            }
            if self.user_update{
                let users = User.allObjects()
                if users.count > 0 {
                    for i in 0...users.count-1{
                        self.userArray[(users[i] as AnyObject).value(forKey: "id") as! String] = users[i] as! User
                    }
                }
            }
            self.clearTable()
            self.genScheduleOnTable()
            if self.schedualArray.count > 0 {
                self.tag = self.schedualArray[self.schedualArray.count-1].tag
            }
            self.view.bringSubview(toFront: self.vw_tab)
            self.view.sendSubview(toBack: self.vw_peak)
        }
//        if self.isConnectedToNetwork(){
//            let setting = Setting.allObjects()
//            let tmp = Temp.allObjects()
//            print("temp"+String(tmp.count))
//            if tmp.count > 0 {
//                for i in 0..<tmp.count{
//                    let t = tmp[i] as! Temp
//                    print(t)
//                    if t.type_of_table == "schedule"{
//                        if t.type == "create"{
//                            for i in 0..<schedualArray.count{
//                                if t.schedule_id == schedualArray[i].id{
//                                    let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(self.schedualArray[i].id)&type=reserve&date=\(self.schedualArray[i].date)&time=\(self.schedualArray[i].time)&price=\(self.schedualArray[i].price)&tag=\(self.schedualArray[i].tag)&userID=\(self.schedualArray[i].userID)&colorTag=\(self.schedualArray[i].colorTag)&paidType=\(self.schedualArray[i].paid_type)&alreadyPaid=\(self.schedualArray[i].already_paid)&sortDate=\(self.schedualArray[i].sort_date)&fieldID=\(self.schedualArray[i].field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                                    print("\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                    Alamofire.request(.POST, "\(self.ip_address)Schedule/create?sportClubID=\(encode!)")
//                                        .responseString { response in
//                                            print("Success: \(response.result.isSuccess)")
//                                            print("Response String: \(response.result.value)")
//                                            if response.result.isSuccess{
//                                                let realm = RLMRealm.default()
//                                                realm.beginWriteTransaction()
//                                                realm.delete(t)
//                                                try! realm.commitWriteTransaction()
//                                            }
//                                    }
//                                }
//                            }
//                        }else if t.type == "update"{
//                            for i in 0..<schedualArray.count{
//                                if t.schedule_id == schedualArray[i].id{
//                                    let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(self.schedualArray[i].id)&type=reserve&date=\(self.schedualArray[i].date)&time=\(self.schedualArray[i].time)&price=\(self.schedualArray[i].price)&tag=\(self.schedualArray[i].tag)&userID=\(self.schedualArray[i].userID)&colorTag=\(self.schedualArray[i].colorTag)&paidType=\(self.schedualArray[i].paid_type)&alreadyPaid=\(self.schedualArray[i].already_paid)&sortDate=\(self.schedualArray[i].sort_date)&fieldID=\(self.schedualArray[i].field)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                                    Alamofire.request(.POST, "\(self.ip_address)Schedule/update?sportClubID=\(encode!)")
//                                        .responseString { response in
//                                            print("Success: \(response.result.isSuccess)")
//                                            print("Response String: \(response.result.value)")
//                                            if response.result.isSuccess{
//                                                let realm = RLMRealm.default()
//                                                realm.beginWriteTransaction()
//                                                realm.delete(t)
//                                                try! realm.commitWriteTransaction()
//                                            }
//                                    }
//                                }
//                            }
//                            
//                        }else{
//                            for i in 0..<schedualArray.count{
//                                if t.schedule_id == schedualArray[i].id{
//                                    let ec = "\((setting[0] as! Setting).sportClub_id)/scheduleID=\(self.schedualArray[i].id)/staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                                    Alamofire.request(.POST, "\(self.ip_address)Schedule/delete/sportClubID=\(ec!)")
//                                        .responseString { response in
//                                            print("Success: \(response.result.isSuccess)")
//                                            print("Response String: \(response.result.value)")
//                                            if response.result.isSuccess{
//                                                let realm = RLMRealm.default()
//                                                realm.beginWriteTransaction()
//                                                realm.delete(t)
//                                                try! realm.commitWriteTransaction()
//                                            }
//                                    }
//                                }
//                            }
//                        }
//                    }else{
//                        if t.type == "create"{
//                            for i in 0..<user_array.count{
//                                if t.user_id == user_array[i].id{
//                                    api.addTempUser(user_array[i], success: { (response) in
//                                        let realm = RLMRealm.default()
//                                        realm.beginWriteTransaction()
//                                        realm.delete(t)
//                                        try! realm.commitWriteTransaction()
//                                        }, failure: {_ in })
//                                }
//                            }
//                        }else{
//                            for i in 0..<user_array.count{
//                                if t.user_id == user_array[i].id{
//                                    api.updateTempUser(user_array[i], success: { (response) in
//                                        let realm = RLMRealm.default()
//                                        realm.beginWriteTransaction()
//                                        realm.delete(t)
//                                        try! realm.commitWriteTransaction()
//                                        }, failure: {_ in })
//                                }
//                            }
//                            
//                        }
//                    }
//                }
//            }
//        }
        self.clearTable()
        self.genScheduleOnTable()
        if self.schedualArray.count > 0 {
            self.tag = self.schedualArray[self.schedualArray.count-1].tag
        }
        self.view.sendSubview(toBack: self.vw_peak)
        self.view.bringSubview(toFront: self.vw_tab)
    }
    func genScheduleOnTable(){
        let h : CGFloat = CGFloat(((1.595*self.view.frame.height)/2)/17)
        let width = (self.view.frame.width)/CGFloat(field_num+1)
        self.btn_date.setTitle(self.real_date, for: UIControlState())
        if schedualArray.count > 0 {
            for i in 0...self.schedualArray.count-1{
                if schedualArray[i].date == real_date {
                    var a : String = self.schedualArray[i].time
                    var range: Range<String.Index> = a.range(of: ".")!
                    let index: Int = a.characters.distance(from: a.startIndex, to: range.lowerBound)
                    let startHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< a.characters.index(a.startIndex, offsetBy: index)))
                    range = a.range(of: " ")!
                    let index1 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
                    var startMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index+1) ..< (a.characters.index(a.startIndex, offsetBy: index1))))
                    a = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index1+3) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
                    range = a.range(of: ".")!
                    let index2 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
                    let endHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< (a.characters.index(a.startIndex, offsetBy: index2))))
                    var endMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index2+1) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
                    startMin = String(Double(startMin)!/60)
                    endMin = String(Double(endMin)!/60)
                    //                    if Double(startMin) == 0.5 && Double(endMin) == 0.5 {
                    //                        endMin = "0.5"
                    //                    }
                    let view = UIView(frame: CGRect(x: CGFloat(Int(self.schedualArray[i].field)!)*width,y: ((CGFloat(Int(startHour)!)-CGFloat(4))*h)+CGFloat(7)+CGFloat(Double(startMin)!)*h,width: width,height: ((CGFloat(Int(endHour)!)-CGFloat(Int(startHour)!)-CGFloat(Double(startMin)!))*h)+CGFloat(Double(endMin)!)*h))
                    view.backgroundColor = self.tableColor.value(forKey: self.schedualArray[i].colorTag)! as! UIColor
                    self.keepTag.append(self.schedualArray[i].tag)
                    view.tag = self.schedualArray[i].tag
                    self.view.addSubview(view)
                    view.layer.borderWidth = 1
                    view.layer.masksToBounds = true
                    view.layer.borderColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0).cgColor
                    let lb = UILabel(frame:CGRect(x: 0,y: 0,width: width,height: view.frame.height/2))
                    lb.text = (self.userArray[schedualArray[i].userID]?.nickName)!
                    lb.textColor = UIColor.white
                    lb.font = UIFont(name: "ThaiSansLite", size: 13)
                    lb.textAlignment = .center
                    view.addSubview(lb)
                    let lb1 = UILabel(frame: CGRect(x: 0,y: view.frame.height/2,width: width,height: view.frame.height/2))
                    lb1.text = (self.userArray[schedualArray[i].userID]?.contact)!
                    lb1.textColor = UIColor.white
                    lb1.font = UIFont(name:"ThaiSansLite", size: 13)
                    lb1.textAlignment = .center
                    view.addSubview(lb1)
                    self.view.sendSubview(toBack: self.problem_view)
                    self.view.sendSubview(toBack: self.vw_peak)
                    self.view.bringSubview(toFront: view)
                    self.view.bringSubview(toFront: lb)
                    self.view.bringSubview(toFront: lb1)
                    self.view.bringSubview(toFront: vw_tab)
                }
            }
        }
        genSlot()
    }
    func clearTable(){
        if keepTag.count > 0 {
            for i in 0...keepTag.count-1 {
                if let viewWithTag = self.view.viewWithTag(keepTag[i]){
                    viewWithTag.removeFromSuperview()
                }
            }
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //print(touch.locationInView(self.view))
        //f = UIView(frame: CGRectMake(touch.locationInView(self.view).x, touch.locationInView(self.view).y, 20, 20))
        self.x = touch.location(in: self.view).x
        self.y = touch.location(in: self.view).y
        if tab_trigger {
            x = touch.location(in: self.view).x
            if x > self.view.frame.width * 11 / 13 {
                enable_touch = !enable_touch
            }
            return true
        }else{
            let width = (self.view.frame.width)/CGFloat(field_num+1)
            
            if self.y > (self.view.frame.height * 0.2025) && self.x > width {
                enable_create_table = true
            }
            return true
        }
        
        //f.backgroundColor = UIColor.blueColor()
        //self.view.addSubview(f)
    }
    func drag(_ gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .changed :
            if enable_create_table{
                let transition = gesture.translation(in: self.view)
                //        print("x "+String(transition.x)+" "+String(self.x))
                //        print("y "+String(transition.y)+" "+String(self.y))
                let h : CGFloat = CGFloat(((1.595*self.view.frame.height)/2)/17)
                var height : Int = Int(transition.y/h)
                if transition.y.truncatingRemainder(dividingBy: h) != 0 {
                    height += 1
                }
                let width = (self.view.frame.width)/CGFloat(field_num+1)
                let tempx : Int = Int(self.x/width) //x position
                let tempy : Int = Int(self.y/h) // y position
                //            print(height)
                let first = (tempy-4)+(16*(tempx-1))
                let second = ((tempy-4)+(height-1))+(16*(tempx-1))
                if hh < transition.y{
                    if first < second {
                        for i in first...second{
                            if slot[i] != "free" {
                                let appearance = SCLAlertView.SCLAppearance(
                                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                                    showCloseButton: true
                                )
                                let alert = SCLAlertView(appearance:appearance)
                                alert.showError("ผิดพลาด", subTitle: "ทับกับตารางอื่น")
                                enable_create_table = !enable_create_table
                                let begin = self.schedualArray[schedualArray.count-1].tag+1
                                if begin < self.tag{
                                    for i in begin...self.tag{
                                        if let tag = self.view.viewWithTag(i) {
                                            if i > self.schedualArray[schedualArray.count-1].tag{
                                                tag.removeFromSuperview()
                                            }
                                        }
                                    }
                                }
                                self.tag = self.schedualArray[schedualArray.count-1].tag
                                break
                            }
                        }
                    }
                }
                if hh > transition.y{
                    drag_top = true
                    if temp_h > 0 {
                        drag_top = false
                    }
                    if temp_h > height {
                        if var tag = self.view.viewWithTag(self.tag) {
                            temp_h = height
                            if self.schedualArray.count > 0 {
                                if self.tag > self.schedualArray[schedualArray.count-1].tag {
                                    tag.removeFromSuperview()
                                }
                            }
                            if schedualArray.count > 0 {
                                if self.tag > self.schedualArray[schedualArray.count-1].tag {
                                    self.tag -= 1
                                }
                            }
                            hh = transition.y
                            //                            if tag.tag <= self.schedualArray[schedualArray.count-1].tag{
                            //
                            //                            }else{
                            //                            tag.removeFromSuperview()
                            //                            }
                        }
                    }
                    
                    //print(tag)
                    //                    if let tag = self.view.viewWithTag(self.tag) {
                    //                        tag.removeFromSuperview()
                    //                    }
                }else{
                    drag_top = false
                }
                if enable_create_table && !drag_top{
                    f = UIView(frame: CGRect(x: (CGFloat(tempx)*width),y: CGFloat(tempy)*h+CGFloat(7),width: width,height: (CGFloat(height)*h)))
                    f.layer.borderWidth = 1
                    f.layer.borderColor = UIColor(red: 225/255, green: 224/255, blue: 225/255, alpha: 1.0).cgColor
                    f.backgroundColor = UIColor(red:232/255,green:81/255,blue:83/255,alpha:1.0)
                    if temp_h < height{
                        f.tag = self.tag+1
                        self.tag+=1
                        self.view.addSubview(f)
                    }
                    //print(self.tag)
                    temp_h = height
                    self.hh = transition.y
                    self.field = String(tempx)
                    var time1 = ""+String(tempy+4)+".00 - "
                    var time2 = ""+String(tempy+height+4)+".00"
                    self.time = "" + time1 + time2
                }
            }
        case .ended :
            self.tag += 1
            if enable_create_table && !drag_top{
                enable_create_table = false
                performSegue(withIdentifier: "addTable", sender: self)
            }
        default : break
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func genTableField(){
        for i in 0...field_num-1 {
            let width = (self.view.frame.width)/CGFloat(field_num+1)
            //print(width)
            let v = UIView(frame: CGRect(x: (width*CGFloat(i))+(width), y: 0, width: 1, height: self.view.frame.height))
            v.backgroundColor = UIColor(red: 225/255, green: 224/255, blue: 225/255, alpha: 1.0)
            var xt = (width*CGFloat(i))+(width)+(width/2)-6
            var yt = self.view.frame.height*CGFloat(0.15)
            let label = UILabel(frame:CGRect(x: xt,y: yt,width: 20,height: 20))
            label.text = String(i+1)
            label.font = UIFont(name: "ThaiSansLite", size: 15)
            label.textColor = UIColor.black
            self.view.addSubview(label)
            self.view.addSubview(v)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTable" {
            if let des = segue.destination as? AddTableViewController {
                des.field = self.field
                let format = DateFormatter()
                format.dateStyle = DateFormatter.Style.full
                des.date = format.date(from: self.real_date)
                des.time = self.time
                des.price = "1000 บาท"
                des.rep = "1 สัปดาห์"
            }
        }
        if segue.identifier == "edit_table" {
            if let des = segue.destination as? AddTableViewController {
                let format = DateFormatter()
                format.dateStyle = DateFormatter.Style.full
                des.date = format.date(from: self.real_date)
                print(self.slot[self.del_slot]!)
                for i in 0..<self.schedualArray.count {
                    if schedualArray[i].id == self.slot[self.del_slot]! {
                        print("UUUU"+schedualArray[i].id)
                        des.time = self.schedualArray[i].time
                        des.price = String(self.schedualArray[i].price)+" บาท"
                        des.rep = "1 สัปดาห์"
                        des.edit = true
                        des.name = userArray[schedualArray[i].userID]?.nickName
                        des.edit = true
                        des.field = schedualArray[i].field
                        des.id = schedualArray[i].id
                        des.tel = userArray[schedualArray[i].userID]?.contact
                    }
                }
            }
        }
        if segue.identifier == "popOver"{
            let vc = segue.destination
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
            }
            let des = segue.destination as! PopOverViewController
            let dateformat = DateFormatter()
            dateformat.dateStyle = DateFormatter.Style.full
            des.hidden_date = dateformat.string(from: Foundation.Date())
        }
    }
    func genSlot(){
        slot = [String?](repeating: nil, count: self.field_num*16)
        for i in 0...slot.count-1{
            slot[i] = "free"
        }
        if schedualArray.count > 0 {
            for i in 0...schedualArray.count-1 {
                if schedualArray[i].date == self.real_date {
                    var a : String = self.schedualArray[i].time
                    var range: Range<String.Index> = a.range(of: ".")!
                    let index: Int = a.characters.distance(from: a.startIndex, to: range.lowerBound)
                    let startHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< a.characters.index(a.startIndex, offsetBy: index)))
                    range = a.range(of: " ")!
                    let index1 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
                    var startMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index+1) ..< (a.characters.index(a.startIndex, offsetBy: index1))))
                    a = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index1+3) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
                    range = a.range(of: ".")!
                    let index2 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
                    let endHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< (a.characters.index(a.startIndex, offsetBy: index2))))
                    var endMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index2+1) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
                    let first = ((Int(startHour)!-8)+(16*(Int(schedualArray[i].field)!-1)))
                    let second = (Int(endHour)!-9)+(16*(Int(schedualArray[i].field)!-1))
                    for j in first...second {
                        slot[j] = schedualArray[i].id
                    }
                }
            }
        }
    }
    func findSlotPosition(_ x:CGFloat,y:CGFloat) -> Bool{
        let width = (self.view.frame.width)/CGFloat(field_num+1)
        let h : CGFloat = CGFloat(((1.595*self.view.frame.height)/2)/17)
        let yy = Int((y-(0.2025*(self.view.frame.height)))/h)
        let xx = Int(x/width)
        let find_slot = ((xx-1)*16)+yy
        if find_slot < 0 {
            return true
        }
        if slot[find_slot] == "free"{
            return true
        }else{
            self.del_slot = find_slot
            return false
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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

