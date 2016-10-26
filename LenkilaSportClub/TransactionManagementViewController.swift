//
//  TransactionManagementViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/17/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
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

class TransactionManagementViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {
    var state_present : Bool = true
    @IBOutlet weak var btn_present_transaction: UIButton!
    @IBOutlet weak var btn_history_transaction: UIButton!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    var tab_trigger = false
    var freq_play_array = [FreqPlay]()
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    var x : CGFloat = 0
    var y : CGFloat = 0
    var enable_touch :Bool = false
    var scheduleArray = [Schedule]()
    var userArray = [User]()
    var cellIdentifier :String! = nil
    @IBOutlet weak var transactionTableView: UITableView!
    @IBAction func btn_tab_action(_ sender: UIButton) {
        trigger_tab()
    }
    let ip_address = "http://128.199.227.19/"
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
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    @IBAction func btn_present_transaction_action(_ sender: UIButton) {
        self.btn_history_transaction.backgroundColor = UIColor(red: 48/255, green: 91/255, blue: 112/255, alpha: 1.0)
        self.btn_present_transaction.backgroundColor = UIColor(red: 46/255, green: 177/255, blue: 135/255, alpha: 1.0)
        state_present = !state_present
        gatherAllData()
    }
    @IBAction func btn_history_transaction_action(_ sender: UIButton) {
        self.btn_present_transaction.backgroundColor = UIColor(red: 48/255, green: 91/255, blue: 112/255, alpha: 1.0)
        self.btn_history_transaction.backgroundColor = UIColor(red: 46/255, green: 177/255, blue: 135/255, alpha: 1.0)
        state_present = !state_present
        gatherAllData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tap_gesture.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gatherAllData()
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if tab_trigger {
            x = touch.location(in: self.view).x
            y = touch.location(in: self.view).y
            if x > self.view.frame.width * 11 / 13 {
                enable_touch = !enable_touch
            }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArray.count
    }
    func gatherAllData(){
        freq_play_array = [FreqPlay]()
        let freq_play = FreqPlay.allObjects()
        if freq_play.count > 0 {
            for i in 0...freq_play.count-1{
                let freq = freq_play[i] as! FreqPlay
                freq_play_array.append(freq)
            }
        }
        let realm = RLMRealm.default()
        realm.beginWriteTransaction()
        sortFreqPlay()
        try! realm.commitWriteTransaction()
        if state_present{
            scheduleArray = [Schedule]()
            userArray = [User]()
            let schedule = Schedule.allObjects()
            if schedule.count > 0 {
                for i in 0...schedule.count-1 {
                    let s = schedule[i] as! Schedule
                    let format = DateFormatter()
                    format.dateStyle = DateFormatter.Style.full
                    print(format.string(from: Foundation.Date()))
                    if !s.already_paid && s.sort_date >= createSortDate(format.string(from: Foundation.Date()), time: "00.00 -") {
                        self.scheduleArray.append(s)
                    }
                    //print(schedule[i])
                }
            }
            let user = User.allObjects()
            if user.count > 0 {
                for i in 0...user.count-1{
                    print(user[i])
                    userArray.append(user[i] as! User)
                }
            }
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            sortDate()
            try! realm.commitWriteTransaction()
            transactionTableView.reloadData()
        }else{
            scheduleArray = [Schedule]()
            userArray = [User]()
            let schedule = Schedule.allObjects()
            if schedule.count > 0 {
                for i in 0...schedule.count-1 {
                    let s = schedule[i] as! Schedule
                    if s.already_paid{
                        scheduleArray.append(s)
                    }
                    print(schedule[i])
                }
            }
            let user = User.allObjects()
            if user.count > 0 {
                for i in 0...user.count-1{
                    userArray.append(user[i] as! User)
                }
            }
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            sortDate()
            try! realm.commitWriteTransaction()
            transactionTableView.reloadData()
            self.transactionTableView.isEditing = false
        }
    }
    func sortDate(){
        print(scheduleArray.count)
        if scheduleArray.count > 0 {
            for i in 0...scheduleArray.count-1{
                let date = scheduleArray[i].date
                let time = scheduleArray[i].time
                scheduleArray[i].sort_date = createSortDate(date, time: time)
            }
        }
        if state_present{
            scheduleArray.sort(by: {$0.sort_date < $1.sort_date})
        }else{
            scheduleArray.sort(by: {$0.sort_date > $1.sort_date})
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if state_present{
            cellIdentifier = "Cell"
        }else{
            cellIdentifier = "cell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if !state_present{
            cell.isUserInteractionEnabled = false
        }
        cell.textLabel?.font = UIFont(name: "ThaiSansLite",size: 16)
        let paid_type = cell.viewWithTag(1)
        switch  scheduleArray[(indexPath as NSIndexPath).row].paid_type {
        case "cash" :
            paid_type?.backgroundColor = UIColor(red: 251/255, green: 199/255, blue: 0/255, alpha: 1.0)
        case "credit" :
            paid_type?.backgroundColor = UIColor(red: 172/255, green: 40/255, blue: 28/255, alpha: 1.0)
        case "debit" :
            paid_type?.backgroundColor = UIColor(red: 152/255, green: 191/255, blue: 0/255, alpha: 1.0)
        default:
            paid_type?.backgroundColor = UIColor.blue
        }
        let name = cell.viewWithTag(2) as! UILabel
        name.text  = "คุณ "+userArray[Int(scheduleArray[(indexPath as NSIndexPath).row].userID)!].nickName
        let contact = cell.viewWithTag(3) as! UILabel
        contact.text = userArray[Int(scheduleArray[(indexPath as NSIndexPath).row].userID)!].contact
        //        let num_field = cell.viewWithTag(4) as! UILabel
        //        num_field.text = "สนาม "+scheduleArray[indexPath.row].field
        let time = cell.viewWithTag(5) as! UILabel
        time.text = scheduleArray[(indexPath as NSIndexPath).row].time
        let day = cell.viewWithTag(6) as! UILabel
        day.text = scheduleArray[(indexPath as NSIndexPath).row].date
        var a : String = self.scheduleArray[(indexPath as NSIndexPath).row].time
        var range: Range<String.Index> = a.range(of: ".")!
        let index: Int = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let startHour = a.substring(with: Range<String.Index>(a.characters.index(a.startIndex, offsetBy: 0)..<a.characters.index(a.startIndex, offsetBy: index)))
        range = a.range(of: " ")!
        let index1 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let startMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index+1) ..< (a.characters.index(a.startIndex, offsetBy: index1))))
        a = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index1+3) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
        range = a.range(of: ".")!
        let index2 = a.characters.distance(from: a.startIndex, to: range.lowerBound)
        let endHour = a.substring(with: (a.characters.index(a.startIndex, offsetBy: 0) ..< (a.characters.index(a.startIndex, offsetBy: index2))))
        let endMin = a.substring(with: (a.characters.index(a.startIndex, offsetBy: index2+1) ..< (a.characters.index(a.endIndex, offsetBy: 0))))
        let profile_pic = cell.viewWithTag(7) as! UIImageView
        profile_pic.layer.cornerRadius = 15
        profile_pic.layer.masksToBounds = true
        //let hour_count = cell.viewWithTag(7) as! UILabel
        var diff_hour = Double(endHour)! - Double(startHour)!
        if Int(startMin)>Int(endMin){
            //hour_count.text = String(Int(endHour)!-Int(startHour)!)+" ชั่วโมง"+" "+"30 นาที"
            diff_hour += 0.5
        }else if Int(startMin)<Int(endMin){
            //hour_count.text = String(Int(endHour)!-Int(startHour)!-1)+" ชั่วโมง"+" "+"30 นาที"
            diff_hour -= 0.5
        }else{
            //hour_count.text = String(Int(endHour)!-Int(startHour)!)+" ชั่วโมง"+" "+"00 นาที"
        }
        let price = cell.viewWithTag(8) as! UILabel
        let numberFormatter = NumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NumberFormatter.Style.currencyISOCode
        price.text = numberFormatter.string(from: (Double(scheduleArray[(indexPath as NSIndexPath).row].price)) as NSNumber)! + " บาท"
        let promotion = cell.viewWithTag(9) as! UILabel
        promotion.text = scheduleArray[(indexPath as NSIndexPath).row].promotion
        return cell
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
    func sortFreqPlay(){
        freq_play_array.sort(by: {$0.userID < $1.userID})
    }
    func updateFreqPlay(_ user_id:String) -> String{
        var freqArray = [Int]()
        var keepFreq = [String:Int]()
        if freq_play_array.count > 0 {
            for i in 0...freq_play_array.count-1 {
                freqArray.append(Int(freq_play_array[i].userID)!)
            }
            let idx = binarySearch(freqArray, searchItem: Int(user_id)!)
            for j in idx...freq_play_array.count-1{
                if user_id != freq_play_array[j].userID{
                    continue
                }
                if keepFreq[freq_play_array[j].freq_play+" "+freq_play_array[j].day] == nil {
                    keepFreq[freq_play_array[j].freq_play+" "+freq_play_array[j].day] = 1
                }else{
                    keepFreq[freq_play_array[j].freq_play+" "+freq_play_array[j].day]! += 1
                }
                
            }
        }
        print(keepFreq)
        return findMaxFreq(keepFreq)
        
    }
    func findMaxFreq(_ freq_play:[String:Int]) -> String{
        var freq_time = ""
        if freq_play.count > 0 {
            var max = 0
            for i in 0...freq_play.count-1{
                let index = freq_play.index(freq_play.startIndex, offsetBy: i)
                if max < freq_play[freq_play.keys[index]]!{
                    max = freq_play[freq_play.keys[index]]!
                    freq_time = freq_play.keys[index]
                }
            }
        }
        return freq_time
    }
    func binarySearch<T:Comparable>(_ inputArr:Array<T>, searchItem: T)->Int{
        var lowerIndex = 0;
        var upperIndex = inputArr.count - 1
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex] == searchItem) {
                if currentIndex != 0 {
                    if inputArr[currentIndex-1] == searchItem{
                        upperIndex = currentIndex - 1
                    }else{
                        return currentIndex
                    }
                }else{
                    return 0
                }
            } else if (lowerIndex > upperIndex) {
                return -1
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let acceptAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{21B5}\n จ่าย" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            let schedule = Schedule.allObjects()
            var id = ""
            var time = ""
            for i in 0...schedule.count-1 {
                let s = schedule[i] as! Schedule
                if s.id == self.scheduleArray[indexPath.row].id {
                    s.already_paid = true
                    try! realm.commitWriteTransaction()
                    //if self.isConnectedToNetwork(){
                        let setting = Setting.allObjects()
//                        let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(s.id)&alreadyPaid=\(s.already_paid)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                        Alamofire.request(.PUT, "\(self.ip_address)Schedule/update?sportClubID=\(encode!)")
//                            .responseString { response in
//                                print("Success: \(response.result.isSuccess)")
//                                print("Response String: \(response.result.value)")
//                                if !response.result.isSuccess{
//                                    let temp = Temp()
//                                    realm.beginWriteTransaction()
//                                    temp.type = "update"
//                                    temp.type_of_table = "schedule"
//                                    temp.schedule_id = s.id
//                                    realm.add(temp)
//                                    try! realm.commitWriteTransaction()
//                                }
//                        }
//                            .responseJSON { response in
//                                debugPrint(response.result.value)
//                                if response.result.value == nil {
//                                    
//                                }else{
//                                    let json = response.result.value as! NSDictionary
//                                    let df = DateFormatter()
//                                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                    realm.beginWriteTransaction()
//                                    s.updated_at = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                    let setting = Setting.allObjects()
//                                    let s = setting[0] as! Setting
//                                    s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                                    try! realm.commitWriteTransaction()
//
//                                }
//                        }
                   // }else{
                        let temp = Temp()
                        realm.beginWriteTransaction()
                        temp.type = "update"
                        temp.type_of_table = "schedule"
                        temp.schedule_id = s.id
                        realm.add(temp)
                        try! realm.commitWriteTransaction()
                    //}
                    realm.beginWriteTransaction()
                        let user = User.allObjects()
                        let freq_play = FreqPlay()
                        if user.count > 0 {
                            for j in 0...user.count-1 {
                                let u = user[j] as! User
                                if u.id == s.userID{
                                    id = u.id
                                    u.playCount += 1
                                    time = s.time
                                    freq_play.userID = id
                                    freq_play.freq_play = time
                                    let range = s.date.range(of: ",")!
                                    let index = s.date.characters.distance(from: s.date.startIndex, to: range.lowerBound)
                                    freq_play.day = s.date.substring(with: (s.date.characters.index(s.date.startIndex, offsetBy: 0) ..< s.date.characters.index(s.date.startIndex, offsetBy: index)))
                                    realm.add(freq_play)
                                }
                            }
                        }
                }
            }
            try! realm.commitWriteTransaction()
            self.gatherAllData()
            realm.beginWriteTransaction()
            let user = User.allObjects()
            if user.count > 0 {
                for i in 0...user.count-1{
                    let u = user[i] as! User
                    if u.id == id {
                        u.freqPlay = self.updateFreqPlay(u.id)
                    }
                }
            }
            try! realm.commitWriteTransaction()
        })
        acceptAction.backgroundColor = UIColor(red: 122/255, green: 190/255, blue: 139/255, alpha: 1.0)
        if state_present{
            return [acceptAction]
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit"{
            let indexPath = self.transactionTableView.indexPathForSelectedRow!
            if let des = segue.destination as? EditTransactionViewController{
                des.schedule = scheduleArray[(indexPath as NSIndexPath).row]
                des.user_name = userArray[Int(scheduleArray[(indexPath as NSIndexPath).row].userID)!].nickName
            }
        }
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
