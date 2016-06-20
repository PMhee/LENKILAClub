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
    @IBAction func btn_tab_action(sender: UIButton) {
        trigger_tab()
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
    @IBAction func tf_first_name_action(sender: UITextField) {
        vw_underline_fisrt_name.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_last_name_action(sender: UITextField) {
        vw_underline_lastname.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_nick_name_action(sender: UITextField) {
        vw_underline_nick_name.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_work_place_action(sender: UITextField) {
        vw_underline_work_place.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func tf_contact_action(sender: UITextField) {
        vw_underline_contact.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
    }
    @IBAction func sm_gender_action(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.gender = "ช"
        }else if sender.selectedSegmentIndex == 1{
            self.gender = "ญ"
        }else{
            self.gender = "ช"
        }
    }
    @IBAction func sd_age_action(sender: UISlider) {
        self.age = Float(Int(sender.value) * 100)
        self.lb_show_age.text = String(Int(sender.value*100)) + " ปี"
    }
    @IBAction func edit_user_action(sender: UIButton) {
        let user = User.allObjects()
        if add_user == nil {
            if Int(self.id)! <= Int(user.count){
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                let u = user[UInt(self.id)!] as! User
                u.name = self.tf_firstname.text! + " " + self.tf_lastname.text!
                u.nickName = self.tf_nickname.text!
                if self.sm_gender.selectedSegmentIndex == 0 {
                    u.gender = "ช"
                }else{
                    u.gender = "ญ"
                }
                let range = self.lb_show_age.text!.rangeOfString(" ")!
                let index = self.lb_show_age.text!.startIndex.distanceTo(range.startIndex)
                let age = self.lb_show_age.text!.substringWithRange(Range<String.Index>(start: lb_show_age.text!.startIndex.advancedBy(0), end: (lb_show_age.text!.startIndex.advancedBy(index))))
                u.age = Int(age)!
                u.workPlace = self.tf_work_place.text!
                u.contact = self.tf_contact.text!
                try! realm.commitWriteTransaction()
                self.performSegueWithIdentifier("send_back_to_user", sender: self)
                // continue save existing user by id
            }
        }else{
            let realm = RLMRealm.defaultRealm()
            let u = User()
            u.name = self.tf_firstname.text! + " " + self.tf_lastname.text!
            u.nickName = self.tf_nickname.text!
            u.id = String(user.count)
            if self.sm_gender.selectedSegmentIndex == 0 {
                u.gender = "ช"
            }else{
                u.gender = "ญ"
            }
            let range = self.lb_show_age.text!.rangeOfString(" ")!
            let index = self.lb_show_age.text!.startIndex.distanceTo(range.startIndex)
            let age = self.lb_show_age.text!.substringWithRange(Range<String.Index>(start: lb_show_age.text!.startIndex.advancedBy(0), end: (lb_show_age.text!.startIndex.advancedBy(index))))
            u.age = Int(age)!
            u.workPlace = self.tf_work_place.text!
            u.contact = self.tf_contact.text!
            realm.beginWriteTransaction()
            realm.addObject(u)
            try! realm.commitWriteTransaction()
            self.performSegueWithIdentifier("send_back_to_user", sender: self)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
        // Do any additional setup after loading the view.
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if tab_trigger {
        x = touch.locationInView(self.view).x
        y = touch.locationInView(self.view).y
            if x > self.view.frame.width * 11 / 13 {
                enable_touch = !enable_touch
            }
        return true
        }else{
            return false
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if enable_touch {
        self.trigger_tab()
        enable_touch = !enable_touch
        return true
        }else{
            return false
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        genUserData()
        delegateAll()
        let attr = NSDictionary(object: UIFont(name: "ThaiSansLite", size: 14.0)!, forKey: NSFontAttributeName)
        self.sm_gender.setTitleTextAttributes(attr as [NSObject: AnyObject], forState: .Normal)
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
            if name != "ไม่มี" {
                let range = name.rangeOfString(" ")!
                let index = name.startIndex.distanceTo(range.startIndex)
                let firstName = name.substringWithRange(Range<String.Index>(start: name.startIndex.advancedBy(0), end: (name.startIndex.advancedBy(index))))
                let lastName = name.substringWithRange(Range<String.Index>(start: name.startIndex.advancedBy(index+1), end: (name.endIndex.advancedBy(0))))
                self.tf_firstname.text = firstName
                self.tf_lastname.text = lastName
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
            let numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_price.text = numberFormatter.stringFromNumber(price as NSNumber)! + " บาท"
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
