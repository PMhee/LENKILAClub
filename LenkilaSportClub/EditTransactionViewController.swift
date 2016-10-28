//
//  EditTransactionViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 8/16/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import Alamofire
import SystemConfiguration
class EditTransactionViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var user_name:String!
    var schedule = Schedule()
    var ip_address : String = "http://128.199.227.19/"
    @IBOutlet weak var cons_top: NSLayoutConstraint!
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var tf_money: UITextField!
    @IBOutlet weak var tf_promotion: UITextField!
    @IBOutlet weak var lb_promotion: UILabel!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gesture: UITapGestureRecognizer!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    var freq_play_array = [FreqPlay]()
    var inEdit = false
    @IBAction func tf_money_begin(_ sender: UITextField) {
        inEdit = true
        let range: Range<String.Index> = self.tf_money.text!.range(of: " ")!
        let index: Int = self.tf_money.text!.characters.distance(from: self.tf_money.text!.startIndex, to: range.lowerBound)
        sender.text = self.tf_money.text!.substring(with: (self.tf_money.text!.characters.index(self.tf_money.text!.startIndex, offsetBy: 0) ..< self.tf_money.text!.characters.index(self.tf_money.text!.startIndex, offsetBy: index)))
    }
    @IBAction func tf_money_end(_ sender: UITextField) {
        lb_money.text = String(self.realPrice-Double(tf_promotion.text!)!)+" บาท"
        sender.text = sender.text!+" บาท"
    }
    @IBAction func btn_confirm(_ sender: UIButton) {
        let realm = RLMRealm.default()
        var id = ""
        var time = ""
        realm.beginWriteTransaction()
        var range: Range<String.Index> = self.lb_money.text!.range(of: " ")!
        var index: Int = self.lb_money.text!.characters.distance(from: self.lb_money.text!.startIndex, to: range.lowerBound)
        self.realPrice = Double(self.lb_money.text!.substring(with: (self.lb_money.text!.characters.index(self.lb_money.text!.startIndex, offsetBy: 0) ..< self.lb_money.text!.characters.index(self.lb_money.text!.startIndex, offsetBy: index))))
        schedule.price = realPrice
        schedule.already_paid = true
        let user = User.allObjects()
        let freq_play = FreqPlay()
        if user.count > 0 {
            for j in 0...user.count-1 {
                let u = user[j] as! User
                if u.id == schedule.userID{
                    id = u.id
                    u.playCount += 1
                    time = schedule.time
                    freq_play.userID = id
                    freq_play.freq_play = time
                    let range = schedule.date.range(of: ",")!
                    let index = schedule.date.characters.distance(from: schedule.date.startIndex, to: range.lowerBound)
                    freq_play.day = schedule.date.substring(with: (schedule.date.characters.index(schedule.date.startIndex, offsetBy: 0) ..< schedule.date.characters.index(schedule.date.startIndex, offsetBy: index)))
                    realm.add(freq_play)
                }
            }
        }
        try! realm.commitWriteTransaction()
        realm.beginWriteTransaction()
        let users = User.allObjects()
        if users.count > 0 {
            for i in 0...user.count-1{
                let u = users[i] as! User
                if u.id == id {
                    u.freqPlay = self.updateFreqPlay(u.id)
                }
            }
        }
        try! realm.commitWriteTransaction()
//        if self.isConnectedToNetwork(){
//            let setting = Setting.allObjects()
//            let encode = "\((setting[0] as! Setting).sportClub_id)&scheduleID=\(schedule.id)&alreadyPaid=\(schedule.already_paid)&price=\(schedule.price)&staffID=\((setting[0] as! Setting).staff_id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//            Alamofire.request(.PUT, "\(self.ip_address)Schedule/update?sportClubID=\(encode!)")
//                .responseString { response in
//                    print("Success: \(response.result.isSuccess)")
//                    print("Response String: \(response.result.value)")
//                    if !response.result.isSuccess{
//                        let temp = Temp()
//                        realm.beginWriteTransaction()
//                        temp.type = "update"
//                        temp.type_of_table = "schedule"
//                        temp.schedule_id = self.schedule.id
//                        realm.add(temp)
//                        try! realm.commitWriteTransaction()
//                    }
//            }
//                .responseJSON { response in
//                    debugPrint(response.result.value)
//                    if response.result.value == nil {
//                        
//                    }else{
//                        let json = response.result.value as! NSDictionary
//                        let df = DateFormatter()
//                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        realm.beginWriteTransaction()
//                        self.schedule.updated_at = df.date(from: json.value(forKey: "updated_at") as! String)!
//                        let setting = Setting.allObjects()
//                        let s = setting[0] as! Setting
//                        s.sche_time_stamp = json.value(forKey: "updated_at") as! String
//                        try! realm.commitWriteTransaction()
//                    }
//            }
//
//        }else{
//            let temp = Temp()
//            realm.beginWriteTransaction()
//            temp.type = "update"
//            temp.type_of_table = "schedule"
//            temp.schedule_id = schedule.id
//            realm.add(temp)
//            try! realm.commitWriteTransaction()
//        }
        self.performSegue(withIdentifier: "confirm", sender: self)
    }
    var realPrice:Double!
    var editPromotion = false
    @IBAction func tf_promotion_edit(_ sender: UITextField) {
        cons_top.constant -= 120
        inEdit = true
        tf_promotion.text = ""
        let range: Range<String.Index> = self.tf_money.text!.range(of: " ")!
        let index: Int = self.tf_money.text!.characters.distance(from: self.tf_money.text!.startIndex, to: range.lowerBound)
        self.realPrice = Double(self.tf_money.text!.substring(with: (self.tf_money.text!.characters.index(self.tf_money.text!.startIndex, offsetBy: 0) ..< self.tf_money.text!.characters.index(self.tf_money.text!.startIndex, offsetBy: index))))
    }
    @IBAction func tf_promotion_end(_ sender: UITextField) {
        cons_top.constant += 120
        lb_money.text = String(self.realPrice-Double(tf_promotion.text!)!)+" บาท"
        editPromotion = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf_money.delegate = self
        self.tf_promotion.delegate = self
        profile_pic.layer.cornerRadius = 55
        profile_pic.layer.masksToBounds = true
        tf_money.text = String(schedule.price)+" บาท"
        lb_promotion.text = schedule.promotion
        name.text = user_name
        tf_money.keyboardType = UIKeyboardType.numberPad
        tf_promotion.keyboardType = UIKeyboardType.numberPad
        let range: Range<String.Index> = self.tf_money.text!.range(of: " ")!
        let index: Int = self.tf_money.text!.characters.distance(from: self.tf_money.text!.startIndex, to: range.lowerBound)
        self.realPrice = Double(self.tf_money.text!.substring(with: (self.tf_money.text!.characters.index(self.tf_money.text!.startIndex, offsetBy: 0) ..< self.tf_money.text!.characters.index(self.tf_money.text!.startIndex, offsetBy: index))))
        lb_date.text = schedule.date
        lb_time.text = "เวลา "+schedule.time
        lb_money.text = String(self.realPrice-Double(tf_promotion.text!)!)+" บาท"
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
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
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if inEdit{
            inEdit = false
            tf_promotion.resignFirstResponder()
            tf_money.resignFirstResponder()
            return true
        }else{
            return false
        }
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
