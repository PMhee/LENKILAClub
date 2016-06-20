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
    }
    @IBAction func btn_history_transaction_action(sender: UIButton) {
        self.btn_present_transaction.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)
        self.btn_history_transaction.backgroundColor = UIColor(red: 122/255, green: 118/255, blue: 119/255, alpha: 1.0)
        state_present = !state_present
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
        print(scheduleArray.count)
        return scheduleArray.count
    }
    func gatherAllData(){
            let schedule = Schedule.allObjects()
            if schedule.count > 0 {
                for i in 0...schedule.count-1 {
                    let s = schedule[i] as! Schedule
                    if !s.already_paid{
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
        transactionTableView.reloadData()
            
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let currentIndex = indexPath.row
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
        var index: Int = a.startIndex.distanceTo(range.startIndex)
        let startHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: a.startIndex.advancedBy(index)))
        range = a.rangeOfString(" ")!
        let index1 = a.startIndex.distanceTo(range.startIndex)
        var startMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index+1), end: (a.startIndex.advancedBy(index1))))
        a = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index1+3), end: (a.endIndex.advancedBy(0))))
        range = a.rangeOfString(".")!
        let index2 = a.startIndex.distanceTo(range.startIndex)
        let endHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: (a.startIndex.advancedBy(index2))))
        var endMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index2+1), end: (a.endIndex.advancedBy(0))))
        let hour_count = cell.viewWithTag(7) as! UILabel
        var diff_hour = Int(endHour)! - Int(startHour)!
        hour_count.text = String(Int(endHour)!-Int(startHour)!)+" ชั่วโมง"
        let price = cell.viewWithTag(8) as! UILabel
        let numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        price.text = numberFormatter.stringFromNumber((scheduleArray[indexPath.row].price * diff_hour) as NSNumber)! + " บาท"
        let accept = cell.viewWithTag(9) as! UIButton
        accept.addTarget(self, action: #selector(self.accept_action), forControlEvents: .TouchUpInside)
        return cell
    }
    func accept_action(sender:UIButton){
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        let schedule = Schedule.allObjects()
        var buttonPress :CGPoint = sender.convertPoint(CGPointZero, toView: self.transactionTableView)
        var indexPath : NSIndexPath = self.transactionTableView.indexPathForRowAtPoint(buttonPress)!
        for i in 0...schedule.count-1 {
            let s = schedule[i] as! Schedule
            if s.id == scheduleArray[indexPath.row].id {
                s.already_paid = true
            }
        }
        try! realm.commitWriteTransaction()
        self.gatherAllData()
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
