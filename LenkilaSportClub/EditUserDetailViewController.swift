//
//  EditUserDetailViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
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

class EditUserDetailViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var name : String! = nil
    var nickName : String! = nil
    var gender : String! = nil
    var age : Float! = nil
    var workPlace : String! = nil
    var playCount : Int! = nil
    var freqPlay : String! = nil
    var contact : String! = nil
    var price : Int! = nil
    var id : String! = nil
    var add_user : Bool! = nil
    var tab_trigger = false
    var x : CGFloat! = nil
    var y : CGFloat! = nil
    var enable_touch = false
    let ip_address = "http://128.199.227.19/"
    @IBOutlet weak var cons_buttom: NSLayoutConstraint!
    @IBOutlet weak var cons_buttom1: NSLayoutConstraint!
    @IBOutlet weak var cons_buttom2: NSLayoutConstraint!
    @IBOutlet weak var cons_buttom3: NSLayoutConstraint!
    @IBOutlet weak var cons_buttom4: NSLayoutConstraint!
    @IBOutlet weak var cons_buttom5: NSLayoutConstraint!
    @IBOutlet weak var cons_buttom6: NSLayoutConstraint!
    @IBOutlet weak var cons_width_vw_tab: NSLayoutConstraint!
    @IBOutlet weak var tf_firstname: UITextField!
    @IBOutlet weak var tf_lastname: UITextField!
    @IBOutlet weak var tf_nickname: UITextField!
    @IBOutlet weak var sm_gender: UISegmentedControl!
    @IBOutlet weak var sd_age: UISlider!
    @IBOutlet weak var tf_work_place: UITextField!
    @IBOutlet weak var lb_play_count: UILabel!
    @IBOutlet weak var lb_freq_play: UILabel!
    @IBOutlet weak var tf_contact: UITextField!
    @IBOutlet weak var vw_underline_fisrt_name: UIView!
    @IBOutlet weak var vw_underline_work_place: UIView!
    @IBOutlet weak var vw_underline_lastname: UIView!
    @IBOutlet weak var vw_underline_nick_name: UIView!
    @IBOutlet weak var vw_underline_contact: UIView!
    @IBOutlet weak var lb_show_age: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    @IBAction func edit_tel(_ sender: UITextField) {
        cons_buttom.constant -= 200
        cons_buttom1.constant -= 200
        cons_buttom2.constant -= 200
        cons_buttom3.constant -= 200
        cons_buttom4.constant -= 250
        cons_buttom5.constant -= 250
        cons_buttom6.constant -= 250
    }
    @IBAction func edit_tel_end(_ sender: UITextField) {
        cons_buttom.constant += 200
        cons_buttom1.constant += 200
        cons_buttom2.constant += 200
        cons_buttom3.constant += 200
        cons_buttom4.constant += 250
        cons_buttom5.constant += 250
        cons_buttom6.constant += 250
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
                    self.cons_width_vw_tab.constant += self.view.frame.width/13
                }
                count += 0.025
            }
        }else{
            //self.UserDetailTableView.userInteractionEnabled = true
            while(count <= 0.25){
                delay(count){
                    self.cons_width_vw_tab.constant -= self.view.frame.width/13
                }
                count += 0.025
            }
            
        }
        tab_trigger = !tab_trigger
    }
    @IBAction func tf_first_name_action(_ sender: UITextField) {
        vw_underline_fisrt_name.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_last_name_action(_ sender: UITextField) {
        vw_underline_lastname.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_nick_name_action(_ sender: UITextField) {
        vw_underline_nick_name.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_work_place_action(_ sender: UITextField) {
        vw_underline_work_place.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_contact_action(_ sender: UITextField) {
        vw_underline_contact.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func sm_gender_action(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.gender = "ช"
        }else if sender.selectedSegmentIndex == 1{
            self.gender = "ญ"
        }else{
            self.gender = "ช"
        }
    }
    @IBAction func sd_age_action(_ sender: UISlider) {
        self.age = Float(Int(sender.value) * 100)
        self.lb_show_age.text = String(Int(sender.value*100)) + " ปี"
    }
    @IBAction func edit_user_action(_ sender: UIButton) {
        let user = User.allObjects()
        if add_user == nil {
            if Int(self.id)! <= Int(user.count){
                let realm = RLMRealm.default()
                realm.beginWriteTransaction()
                print(self.id)
                let u = user[UInt(self.id)!] as! User
                u.name = self.tf_firstname.text! + " " + self.tf_lastname.text!
                u.nickName = self.tf_nickname.text!
                if self.sm_gender.selectedSegmentIndex == 0 {
                    u.gender = "ช"
                }else{
                    u.gender = "ญ"
                }
                let range = self.lb_show_age.text!.range(of: " ")!
                let index = self.lb_show_age.text!.characters.distance(from: self.lb_show_age.text!.startIndex, to: range.lowerBound)
                let age = self.lb_show_age.text!.substring(with: (lb_show_age.text!.characters.index(lb_show_age.text!.startIndex, offsetBy: 0) ..< (lb_show_age.text!.characters.index(lb_show_age.text!.startIndex, offsetBy: index))))
                u.age = Int(age)!
                u.workPlace = self.tf_work_place.text!
                u.contact = self.tf_contact.text!
                try! realm.commitWriteTransaction()
//                if isConnectedToNetwork(){
//                    let setting = Setting.allObjects()
//                    let encode = "\((setting[0] as! Setting).sportClub_id)&staffID=\((setting[0] as! Setting).staff_id)&telephone=\(u.contact)&nickName=\(u.nickName)&gender=\(u.gender)&playCount=\(u.playCount)&firstName=\(tf_firstname.text!)&lastName=\(tf_lastname.text!)&workplace=\(u.workPlace)&freqPlay=\(u.freqPlay)&age=\(u.age)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//                    Alamofire.request(.PUT, "\(ip_address)User/update?sportClubID=\(encode!)")
//                        .validate()
//                        .responseString { response in
//                            print("Success: \(response.result.isSuccess)")
//                            print("Response String: \(response.result.value)")
//                            if !response.result.isSuccess{
//                                
//                            }
//                        }.responseJSON { response in
//                            debugPrint(response.result.value)
//                            if response.result.value == nil {
//                                let temp = Temp()
//                                realm.beginWriteTransaction()
//                                temp.type = "update"
//                                temp.type_of_table = "user"
//                                temp.schedule_id = u.id
//                                realm.add(temp)
//                                try! realm.commitWriteTransaction()
//                            }else{
//                                let json = response.result.value as! NSDictionary
//                                let df = DateFormatter()
//                                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                realm.beginWriteTransaction()
//                                u.updated_at = df.date(from: json.value(forKey: "updated_at") as! String)!
//                                let setting = Setting.allObjects()
//                                let s = setting[0] as! Setting
//                                s.user_time_stamp = json.value(forKey: "updated_at") as! String
//                                try! realm.commitWriteTransaction()
//                            }
//                    }
//                    
//                }else{
//                    let temp = Temp()
//                    realm.beginWriteTransaction()
//                    temp.type = "update"
//                    temp.type_of_table = "user"
//                    temp.schedule_id = u.id
//                    realm.add(temp)
//                    try! realm.commitWriteTransaction()
//                }
                self.performSegue(withIdentifier: "send_back_to_user", sender: self)
                // continue save existing user by id
            }
        }else{
            let realm = RLMRealm.default()
            let u = User()
            u.name = self.tf_firstname.text! + " " + self.tf_lastname.text!
            u.nickName = self.tf_nickname.text!
            u.id = String(user.count)
            if self.sm_gender.selectedSegmentIndex == 0 {
                u.gender = "ช"
            }else{
                u.gender = "ญ"
            }
            let range = self.lb_show_age.text!.range(of: " ")!
            let index = self.lb_show_age.text!.characters.distance(from: self.lb_show_age.text!.startIndex, to: range.lowerBound)
            let age = self.lb_show_age.text!.substring(with: (lb_show_age.text!.characters.index(lb_show_age.text!.startIndex, offsetBy: 0) ..< (lb_show_age.text!.characters.index(lb_show_age.text!.startIndex, offsetBy: index))))
            u.age = Int(age)!
            u.workPlace = self.tf_work_place.text!
            u.contact = self.tf_contact.text!
            realm.beginWriteTransaction()
            if u.nickName == "" {
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("ยกเลิก", action: {
                })
                alert.showError("ผิดพลาด", subTitle: "กรุณาใส่ชื่อเล่น")
            }else{
            var found = false
            let user = User.allObjects()
                if user.count > 0 {
                    for i in 0...user.count-1{
                        let  us = user[i] as! User
                        if u.nickName == us.nickName {
                            found = true
                            continue
                        }
                    }
                }
                if found {
                    let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                        kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                        kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("ยกเลิก", action: {
                    })
                    alert.showError("ผิดพลาด", subTitle: "ชื่อผู้เล่นซ้ำ")
                }else{
            realm.add(u)
                    try! realm.commitWriteTransaction()
                    
                    
                    
                }
            self.performSegue(withIdentifier: "send_back_to_user", sender: self)
                }
            }
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
        // Do any additional setup after loading the view.
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        genUserData()
        delegateAll()
        let attr = NSDictionary(object: UIFont(name: "ThaiSansLite", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        self.sm_gender.setTitleTextAttributes(attr as! [AnyHashable: Any], for: UIControlState())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func delegateAll(){
        self.tf_contact.delegate = self
        self.tf_work_place.delegate = self
        self.tf_nickname.delegate = self
        self.tf_lastname.delegate = self
        self.tf_firstname.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        vw_underline_fisrt_name.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
        vw_underline_lastname.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
        vw_underline_contact.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
        vw_underline_work_place.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
        vw_underline_nick_name.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
        textField.resignFirstResponder()
        return true
    }
    //    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    //        if self.view.frame.width < 700 {
    //            return UIInterfaceOrientationMask.Landscape
    //        }else{
    //            return UIInterfaceOrientationMask.Portrait
    //    }
    //    }
    func genUserData(){
        if add_user == nil {
            if name != "" || name != "ไม่มี" || name != nil || name != " "{
                let range = name.range(of: " ")
                if range != nil {
                let index = name.distance(from: name.startIndex, to: range!.lowerBound)
                let firstName = name.substring(with: (name.index(name.startIndex, offsetBy: 0) ..< (name.index(name.startIndex, offsetBy: index))))
                let lastName = name.substring(with: (name.index(name.startIndex, offsetBy: index+1) ..< (name.index(name.endIndex, offsetBy: 0))))
                self.tf_firstname.text = firstName
                self.tf_lastname.text = lastName
                }else{
                    self.tf_firstname.text = ""
                    self.tf_lastname.text = ""
                }
            }else{
                self.tf_firstname.text = ""
                self.tf_lastname.text = ""
            }
            self.tf_nickname.text = nickName
            if gender == "ช" {
                sm_gender.selectedSegmentIndex = 0
            }else if gender == "ญ"{
                sm_gender.selectedSegmentIndex = 1
            }else{
                sm_gender.selectedSegmentIndex = 0
            }
            self.lb_show_age.text = String(Int(self.age))+" ปี"
            sd_age.value = Float(self.age/100)
            tf_work_place.text = workPlace
            lb_play_count.text = String(playCount)
            lb_freq_play.text = freqPlay
            tf_contact.text = contact
            let numberFormatter = NumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NumberFormatter.Style.currencyISOCode
            lb_price.text = numberFormatter.string(from: price as NSNumber)! + " บาท"
        }
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
//func isConnectedToNetwork() -> Bool {
//    var zeroAddress = sockaddr_in()
//    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//    zeroAddress.sin_family = sa_family_t(AF_INET)
//    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//    }
//    var flags = SCNetworkReachabilityFlags()
//    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//        return false
//    }
//    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//    return (isReachable && !needsConnection)
//}
    /*
     // MARK: - Navigation
 
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
