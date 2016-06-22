//
//  TransactionManagementViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/17/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
class TransactionManagementViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var state_present : Bool = true
    @IBOutlet weak var btn_present_transaction: UIButton!
    @IBOutlet weak var btn_history_transaction: UIButton!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    var tab_trigger = false
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    var x : CGFloat = 0
    var y : CGFloat = 0
    var enable_touch :Bool = false
    var scheduleArray = [Schedule]()
    var userArray = [User]()
    var cellIdentifier :String! = nil
    @IBOutlet weak var transactionTableView: UITableView!
    @IBAction func btn_tab_action(sender: UIButton) {
        trigger_tab()
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
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    @IBAction func btn_present_transaction_action(sender: UIButton) {
        self.btn_history_transaction.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)
        self.btn_present_transaction.backgroundColor = UIColor(red: 122/255, green: 118/255, blue: 119/255, alpha: 1.0)
        state_present = !state_present
        gatherAllData()
    }
    @IBAction func btn_history_transaction_action(sender: UIButton) {
        self.btn_present_transaction.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)
        self.btn_history_transaction.backgroundColor = UIColor(red: 122/255, green: 118/255, blue: 119/255, alpha: 1.0)
        state_present = !state_present
        gatherAllData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tap_gesture.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherAllData()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArray.count
    }
    func gatherAllData(){
        if state_present{
            scheduleArray = [Schedule]()
            userArray = [User]()
            let schedule = Schedule.allObjects()
            if schedule.count > 0 {
                for i in 0...schedule.count-1 {
                    let s = schedule[i] as! Schedule
                    let format = NSDateFormatter()
                    format.dateStyle = NSDateFormatterStyle.FullStyle
                    print(format.stringFromDate(NSDate()))
                    if !s.already_paid && s.sort_date >= createSortDate(format.stringFromDate(NSDate()), time: "00.00 -") {
                        self.scheduleArray.append(s)
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
            let realm = RLMRealm.defaultRealm()
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
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            sortDate()
            try! realm.commitWriteTransaction()
            transactionTableView.reloadData()
            self.transactionTableView.editing = false
        }
    }
    func sortDate(){
        for i in 0...scheduleArray.count-1{
            let date = scheduleArray[i].date
            let time = scheduleArray[i].time
            scheduleArray[i].sort_date = createSortDate(date, time: time)
        }
        if state_present{
            scheduleArray.sortInPlace({$0.sort_date < $1.sort_date})
        }else{
            scheduleArray.sortInPlace({$0.sort_date > $1.sort_date})
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if state_present{
            cellIdentifier = "Cell"
        }else{
            cellIdentifier = "cell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let paid_type = cell.viewWithTag(1) as! UILabel
        switch  scheduleArray[indexPath.row].paid_type {
        case "cash" :
            paid_type.text = "ชำระหน้าร้าน"
        case "credit" :
            paid_type.text = "บัตรเครดิต"
        case "debit" :
            paid_type.text = "บัตรเงินสด"
        default:
            paid_type.text = ""
        }
        let name = cell.viewWithTag(2) as! UILabel
        name.text  = "คุณ "+userArray[Int(scheduleArray[indexPath.row].userID)!].nickName
        let contact = cell.viewWithTag(3) as! UILabel
        contact.text = userArray[Int(scheduleArray[indexPath.row].userID)!].contact
        let num_field = cell.viewWithTag(4) as! UILabel
        num_field.text = "สนาม "+scheduleArray[indexPath.row].field
        let time = cell.viewWithTag(5) as! UILabel
        time.text = "เวลา "+scheduleArray[indexPath.row].time
        let day = cell.viewWithTag(6) as! UILabel
        day.text = scheduleArray[indexPath.row].date
        var a : String = self.scheduleArray[indexPath.row].time
        var range: Range<String.Index> = a.rangeOfString(".")!
        let index: Int = a.startIndex.distanceTo(range.startIndex)
        let startHour = a.substringWithRange(Range<String.Index>(a.startIndex.advancedBy(0)..<a.startIndex.advancedBy(index)))
        range = a.rangeOfString(" ")!
        let index1 = a.startIndex.distanceTo(range.startIndex)
        let startMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index+1), end: (a.startIndex.advancedBy(index1))))
        a = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index1+3), end: (a.endIndex.advancedBy(0))))
        range = a.rangeOfString(".")!
        let index2 = a.startIndex.distanceTo(range.startIndex)
        let endHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: (a.startIndex.advancedBy(index2))))
        let endMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index2+1), end: (a.endIndex.advancedBy(0))))
        let hour_count = cell.viewWithTag(7) as! UILabel
        var diff_hour = Double(endHour)! - Double(startHour)!
        if Int(startMin)>Int(endMin){
        hour_count.text = String(Int(endHour)!-Int(startHour)!)+" ชั่วโมง"+":"+"30 นาที"
        diff_hour += 0.5
        }else if Int(startMin)<Int(endMin){
        hour_count.text = String(Int(endHour)!-Int(startHour)!-1)+" ชั่วโมง"+":"+"30 นาที"
        diff_hour -= 0.5
        }else{
        hour_count.text = String(Int(endHour)!-Int(startHour)!)+" ชั่วโมง"+":"+"00 นาที"
        }
        let price = cell.viewWithTag(8) as! UILabel
        let numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        price.text = numberFormatter.stringFromNumber((Double(scheduleArray[indexPath.row].price) * diff_hour) as NSNumber)! + " บาท"
        return cell
    }
    func createSortDate(date:String,var time:String)->Int{
        let dateFormatt = NSDateFormatter()
        dateFormatt.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatt.dateFromString(date)
        let formatt = NSDateFormatter()
        formatt.dateStyle = NSDateFormatterStyle.ShortStyle
        var d = formatt.stringFromDate(dateFormatt.dateFromString(date)!)
        var range = d.rangeOfString("/")!
        var index = d.startIndex.distanceTo(range.startIndex)
        var month = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(0), end: d.startIndex.advancedBy(index)))
        d = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(index+1), end: d.endIndex.advancedBy(0)))
        range = d.rangeOfString("/")!
        index = d.startIndex.distanceTo(range.startIndex)
        if month.characters.count == 1 {
            month = "0"+month
        }
        var day = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(0), end: d.startIndex.advancedBy(index)))
        if day.characters.count == 1 {
            day = "0"+day
        }
        var year = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(index+1), end: d.endIndex.advancedBy(0)))
        range = time.rangeOfString(".")!
        index = time.startIndex.distanceTo(range.startIndex)
        var startHour = time.substringWithRange(Range<String.Index>(start: time.startIndex.advancedBy(0), end: time.startIndex.advancedBy(index)))
        if startHour.characters.count == 1 {
            startHour = "0"+startHour
        }
        time = time.substringWithRange(Range<String.Index>(start: time.startIndex.advancedBy(index+1), end: time.endIndex.advancedBy(0)))
        range = time.rangeOfString(" ")!
        index = time.startIndex.distanceTo(range.startIndex)
        var startMin = time.substringWithRange(Range<String.Index>(start: time.startIndex.advancedBy(0), end: time.startIndex.advancedBy(index)))
        return Int(year+month+day+startHour+startMin)!
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let acceptAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "ชำระ" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            let schedule = Schedule.allObjects()
            for i in 0...schedule.count-1 {
                let s = schedule[i] as! Schedule
                if s.id == self.scheduleArray[indexPath.row].id {
                    s.already_paid = true
                }
            }
            try! realm.commitWriteTransaction()
            self.gatherAllData()
        })
        acceptAction.backgroundColor = UIColor(red: 122/255, green: 190/255, blue: 139/255, alpha: 1.0)
        if state_present{
            return [acceptAction]
        }else{
            return nil
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
