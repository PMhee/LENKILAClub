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
class AddTableViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var field : String!
    var date : NSDate!
    var time : String!
    var name : String!
    var price : String!
    var rep : String!
    var realPrice : Int!
    var pickedColor : String = "red"
    var type :String = "reserve"
    var realRep : Int!
    var x : CGFloat! = nil
    var y : CGFloat! = nil
    var enable_touch : Bool = false
    var not_found :Bool = false
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    @IBOutlet var tab_gesture: UITapGestureRecognizer!
    var checkedArray = [UIImageView]()
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tf_field: UITextField!
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_time: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_price: UITextField!
    @IBOutlet weak var tf_repeat: UITextField!
    @IBOutlet weak var line_field: UIView!
    @IBOutlet weak var line_date: UIView!
    @IBOutlet weak var line_time: UIView!
    @IBOutlet weak var line_name: UIView!
    @IBOutlet weak var line_repeat: UIView!
    @IBOutlet weak var line_price: UIView!
    @IBOutlet weak var btn_inc_30: UIButton!
    @IBOutlet weak var btn_dec_30: UIButton!
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
    var tab_trigger : Bool = false
    @IBAction func btn_inc_30_action(sender: UIButton) {
        calculateTime(true)
    }
    @IBAction func btn_dec_30_action(sender: UIButton) {
        calculateTime(false)
    }
    @IBOutlet weak var top_space: NSLayoutConstraint!
    @IBAction func tf_field_action(sender: UITextField) {
        line_field.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_date_action(sender: UITextField) {
        line_date.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_time_action(sender: UITextField) {
        line_time.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_name_action(sender: UITextField) {
        line_name.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_price_action(sender: UITextField) {
        line_price.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
        top_space.constant -= 20
        sender.text = String(self.realPrice)
    }
    @IBAction func tf_repeat_action(sender: UITextField) {
        line_repeat.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
        top_space.constant -= 55
        sender.text = String(self.realRep)
    }
    @IBAction func btn_tab_view_action(sender: UIButton) {
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
    
    @IBAction func tf_repeat_end(sender: UITextField) {
        top_space.constant += 55
        sender.text = sender.text!+" สัปดาห์"
        var range = sender.text!.rangeOfString(" ")!
        var index = sender.text!.startIndex.distanceTo(range.startIndex)
        self.realRep = Int(sender.text!.substringWithRange(Range<String.Index>(start:sender.text!.startIndex.advancedBy(0), end: sender.text!.startIndex.advancedBy(index))))
    }
    @IBAction func tf_price_end(sender: UITextField) {
        top_space.constant += 20
        sender.text = sender.text!+" บาท"
        var range = sender.text!.rangeOfString(" ")!
        var index = sender.text!.startIndex.distanceTo(range.startIndex)
        self.realPrice = Int(sender.text!.substringWithRange(Range<String.Index>(start:sender.text!.startIndex.advancedBy(0), end: sender.text!.startIndex.advancedBy(index))))
    }
    @IBAction func btn_green_action(sender: UIButton) {
        self.pickedColor = "green"
        setButChecked(0)
    }
    @IBAction func btn_gray_action(sender: UIButton) {
        self.pickedColor = "gray"
        setButChecked(1)
    }
    @IBAction func btn_dark_blue_action(sender: UIButton) {
        self.pickedColor = "dark_blue"
        setButChecked(2)
    }
    @IBAction func btn_blue_action(sender: UIButton) {
        self.pickedColor = "blue"
        setButChecked(3)
    }
    @IBAction func btn_yellow_action(sender: UIButton) {
        self.pickedColor = "yellow"
        setButChecked(4)
    }
    @IBAction func btn_orange_action(sender: UIButton) {
        self.pickedColor = "orange"
        setButChecked(5)
    }
    @IBAction func btn_pink_action(sender: UIButton) {
        self.pickedColor = "pink"
        setButChecked(6)
    }
    @IBAction func btn_red_action(sender: UIButton) {
        self.pickedColor = "red"
        setButChecked(7)
    }
    @IBAction func segment_action(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.type = "reserve"
        }else if sender.selectedSegmentIndex == 1 {
            self.type = "course"
        }
    }
    
    func calculateTime(time:Bool){
        let a : String = self.time
        var range: Range<String.Index> = a.rangeOfString(" ")!
        var index: Int = a.startIndex.distanceTo(range.startIndex)
        var sHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: a.startIndex.advancedBy(2)))
        var sMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(3), end: a.startIndex.advancedBy(5)))
        var eMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(11), end: (a.endIndex.advancedBy(0))))
        var eHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(8), end: a.startIndex.advancedBy(10)))
        var startHour : Int = Int(sHour)!
        var startMin : Int = Int(sMin)!
        var endHour : Int = Int(eHour)!
        var endMin : Int  = Int(eMin)!
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
        tf_time.text = self.time
    }
    @IBAction func btn_add_action(sender: AnyObject) {
        let realm = RLMRealm.defaultRealm()
        let schedule = Schedule()
        let sche = Schedule.allObjects()
        schedule.field = self.field
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        schedule.date = format.stringFromDate(self.date)
        schedule.time = self.time
        schedule.price = self.realPrice
        schedule.tag = Int(sche.count)+1
        schedule.colorTag = self.pickedColor
        schedule.type = self.type
        schedule.id = String(sche.count)
        let range = self.rep.rangeOfString(" ")!
        let index = self.rep.startIndex.distanceTo(range.startIndex)
        self.realRep = Int(self.tf_repeat.text!.substringWithRange(Range<String.Index>(start:self.tf_repeat.text!.startIndex.advancedBy(0), end: self.tf_repeat.text!.startIndex.advancedBy(index))))
        var temp = schedule.date
        if self.realRep >= 2 {
            self.realRep = self.realRep - 1
            for i in 0...self.realRep {
                let schedules = Schedule()
                let sche = Schedule.allObjects()
                schedules.field = self.field
                let format = NSDateFormatter()
                format.dateStyle = NSDateFormatterStyle.FullStyle
                if schedules.date == "" {
                    schedules.date = temp
                }
                if i == 0 {
                }else{
                let nextDay = format.dateFromString(schedules.date)?.dateByAddingTimeInterval(60*60*24*7)
                schedules.date = format.stringFromDate(nextDay!)
                }
                schedules.time = self.time
                schedules.price = self.realPrice
                schedules.tag = Int(sche.count)+1
                schedules.colorTag = self.pickedColor
                schedules.type = self.type
                schedules.id = String(sche.count)
                let users = User.allObjects()
                var found = false
                if users.count > 0 {
                for i in 0...users.count-1{
                    let user : User = users[i] as! User
                    if tf_name.text! == user.nickName{
                        print("found")
                        schedules.userID = user.id
                        found = true
                        continue
                    }
                }
                }
                if found {
                    temp = schedules.date
                    realm.beginWriteTransaction()
                    realm.addObject(schedules)
                    try! realm.commitWriteTransaction()
                }else{
                    not_found = true
                    continue
                }
            }
            if not_found{
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("เพิ่มสมาชิก", action: {
                    let realm = RLMRealm.defaultRealm()
                    let users = User.allObjects()
                    let user = User()
                    user.id = String(users.count)
                    user.nickName = self.tf_name.text!
                    realm.beginWriteTransaction()
                    realm.addObject(user)
                    try! realm.commitWriteTransaction()
                    let schedule = Schedule()
                    let sche = Schedule.allObjects()
                    schedule.field = self.field
                    let format = NSDateFormatter()
                    format.dateStyle = NSDateFormatterStyle.FullStyle
                    schedule.date = format.stringFromDate(self.date)
                    schedule.time = self.time
                    schedule.price = self.realPrice
                    schedule.tag = Int(sche.count)+1
                    schedule.colorTag = self.pickedColor
                    schedule.type = self.type
                    schedule.id = String(sche.count)
                    let range = self.rep.rangeOfString(" ")!
                    let index = self.rep.startIndex.distanceTo(range.startIndex)
                    self.realRep = Int(self.tf_repeat.text!.substringWithRange(Range<String.Index>(start:self.tf_repeat.text!.startIndex.advancedBy(0), end: self.tf_repeat.text!.startIndex.advancedBy(index))))
                    var temp = schedule.date
                    if self.realRep >= 2 {
                        self.realRep = self.realRep - 1
                        for i in 0...self.realRep {
                            let schedules = Schedule()
                            let sche = Schedule.allObjects()
                            schedules.field = self.field
                            let format = NSDateFormatter()
                            format.dateStyle = NSDateFormatterStyle.FullStyle
                            if schedules.date == "" {
                                schedules.date = temp
                            }
                            if i == 0 {
                            }else{
                                let nextDay = format.dateFromString(schedules.date)?.dateByAddingTimeInterval(60*60*24*7)
                                schedules.date = format.stringFromDate(nextDay!)
                            }
                            schedules.time = self.time
                            schedules.price = self.realPrice
                            schedules.tag = Int(sche.count)+1
                            schedules.colorTag = self.pickedColor
                            schedules.type = self.type
                            schedules.userID = user.id
                            schedules.id = String(sche.count)
                            temp = schedules.date
                            realm.beginWriteTransaction()
                            realm.addObject(schedules)
                            try! realm.commitWriteTransaction()
                        }
                        self.performSegueWithIdentifier("back_to_schedule", sender: self)
                    }
                })
                alert.addButton("ยกเลิก", action: {
                    self.not_found = false
                })
                alert.showWarning("เตือน", subTitle: "ไม่มีสมาชิกชื่อนี้อยู่ในข้อมูล")
            }else{
            self.performSegueWithIdentifier("back_to_schedule", sender: self)
            }
        }else{
            let users = User.allObjects()
            var found = false
            if users.count > 0 {
            for i in 0...users.count-1{
                let user : User = users[i] as! User
                if tf_name.text! == user.nickName{
                    print("found")
                    schedule.userID = user.id
                    found = true
                    continue
                }
            }
            }
            if found {
                realm.beginWriteTransaction()
                realm.addObject(schedule)
                try! realm.commitWriteTransaction()
                self.performSegueWithIdentifier("back_to_schedule", sender: self)
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
                    user.id = String(users.count)
                    user.nickName = self.tf_name.text!
                    realm.beginWriteTransaction()
                    realm.addObject(user)
                    schedule.userID = user.id
                    realm.addObject(schedule)
                    try! realm.commitWriteTransaction()
                    self.performSegueWithIdentifier("back_to_schedule", sender: self)
                })
                alert.addButton("ยกเลิก", action: {
                    
                })
                alert.showWarning("เตือน", subTitle: "ไม่มีสมาชิกชื่อนี้อยู่ในข้อมูล")
            }
        }
    }
    @IBAction func btn_cancel_action(sender: AnyObject) {
    }
    func setButChecked(checked:Int){
        for i in 0...checkedArray.count-1{
            if i != checked{
                checkedArray[i].hidden = true
            }else{
                checkedArray[i].hidden = false
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
        let attr = NSDictionary(object: UIFont(name: "ThaiSansLite", size: 17.0)!, forKey: NSFontAttributeName)
        self.segment.setTitleTextAttributes(attr as [NSObject: AnyObject], forState: .Normal)
        tf_name.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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
    
    func genDelegate(){
        tf_field.delegate = self
        tf_date.delegate = self
        tf_time.delegate = self
        tf_name.delegate = self
        tf_price.delegate = self
        tf_repeat.delegate = self
    }
    func genTextField(){
        tf_field.text = self.field
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        tf_date.text = format.stringFromDate(self.date)
        tf_time.text = self.time
        tf_repeat.text = self.rep
        tf_price.text = self.price
        var range: Range<String.Index> = self.price.rangeOfString(" ")!
        var index: Int = self.price.startIndex.distanceTo(range.startIndex)
        self.realPrice = Int(self.price.substringWithRange(Range<String.Index>(start:self.price.startIndex.advancedBy(0), end: self.price.startIndex.advancedBy(index))))
        range = self.rep.rangeOfString(" ")!
        index = self.rep.startIndex.distanceTo(range.startIndex)
        self.realRep = Int(self.tf_repeat.text!.substringWithRange(Range<String.Index>(start:self.tf_repeat.text!.startIndex.advancedBy(0), end: self.tf_repeat.text!.startIndex.advancedBy(index))))
    }
    func genButton(){
        btn_dec_30.layer.cornerRadius = 15
        btn_inc_30.layer.cornerRadius = 15
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
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        line_field.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_date.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_time.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_name.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_price.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_repeat.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        textField.resignFirstResponder()
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "back_to_schedule" {
            if let des = segue.destinationViewController as? ScheduleViewController {
                let format = NSDateFormatter()
                format.dateStyle = NSDateFormatterStyle.FullStyle
                des.date = format.stringFromDate(self.date)
                des.firstTime = true
            }
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
