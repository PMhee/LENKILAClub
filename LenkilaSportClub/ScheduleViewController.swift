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
class ScheduleViewController: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    //    @IBOutlet weak var view_time: UIView!
    //    @IBOutlet weak var scrollView_table: UIScrollView!
    //    @IBOutlet weak var scrollView_page: UIScrollView!
    //    @IBOutlet weak var cons_top_view: NSLayoutConstraint!
    //    @IBOutlet weak var cons_lead_view: NSLayoutConstraint!
    //    var changeHeight : CGFloat!
    //    var changeWidth: CGFloat!
    var tag : Int = 0
    var temp_tag : Int = 0
    var drag_top : Bool = false
    @IBOutlet var long_gesture: UILongPressGestureRecognizer!
    @IBOutlet weak var vw_tab: UIView!
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    @IBOutlet weak var label_date: UILabel!
    var enable_create_table : Bool = false
    var create_table : Bool = false
    var schedualArray = [Schedule]()
    var userArray = [String:User]()
    var keepTag = [Int]()
    var slot = [String?]()
    var firstTime : Bool = false
    let tableColor : NSDictionary = ["green":UIColor(red:122/255,green:190/255,blue:139/255,alpha:1.0),"gray":UIColor(red:122/255,green:118/255,blue:119/255,alpha:1.0),"dark_blue":UIColor(red:84/255,green:110/255,blue:122/255,alpha:1.0),"blue":UIColor(red:16/255,green:118/255,blue:152/255,alpha:1.0),"yellow":UIColor(red:252/255,green:221/255,blue:121/255,alpha:1.0),"orange":UIColor(red:231/255,green:158/255,blue:63/255,alpha:1.0),"pink":UIColor(red:205/255,green:122/255,blue:121/255,alpha:1.0),"red":UIColor(red:232/255,green:81/255,blue:83/255,alpha:1.0)]
    var f : UIView! = nil
    var x : CGFloat! = nil
    var y : CGFloat! = nil
    let field_num = 4
    var hh  :CGFloat = 0.0
    var field : String!
    var date : String!
    var time : String!
    var name : String!
    var price : String!
    var rep : String!
    var today = NSDate()
    var tab_trigger : Bool = false
    var enable_touch : Bool = false
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
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
    @IBAction func btn_left_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        label_date.text = format.stringFromDate(format.dateFromString(label_date.text!)!.dateByAddingTimeInterval(-60*60*24))
        //today = today.dateByAddingTimeInterval(-60*60*24)
        clearTable()
        self.genScheduleOnTable()
    }
    @IBAction func btn_today_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        label_date.text = format.stringFromDate(NSDate())
        clearTable()
        self.genScheduleOnTable()
    }
    @IBAction func btn_right_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        label_date.text = format.stringFromDate(format.dateFromString(label_date.text!)!.dateByAddingTimeInterval(60*60*24))
        //today = today.dateByAddingTimeInterval(60*60*24)
        clearTable()
        self.genScheduleOnTable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.delegate = self
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ScheduleViewController.drag(_:)))
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(tapGesture)
        self.genTableField()
        btn_today.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if firstTime {
            self.label_date.text = self.date
        }else{
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            label_date.text = format.stringFromDate(NSDate())
        }
        //        let realm = RLMRealm.defaultRealm()
        //        let user = User()
        //        user.age = 22
        //        user.contact = "099-2850130"
        //        let format = NSDateFormatter()
        //        format.timeStyle = NSDateFormatterStyle.ShortStyle
        //        user.freqPlay = format.stringFromDate(NSDate())
        //        user.gender = "ชาย"
        //        user.id = "1111"
        //        user.name = "ธนากร รัตนจริยา"
        //        user.nickName = "นนท์"
        //        user.playCount = 4
        //        user.price = 1000
        //        user.workPlace = "Lenkila"
        //        realm.beginWriteTransaction()
        //        realm.addObject(user)
        //        try! realm.commitWriteTransaction()
        //        let sche = Schedule()
        //        let formatter = NSDateFormatter()
        //        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        //        sche.date = "Friday, June 3, 2016"
        //        sche.time = "18.00 - 20.30"
        //        sche.field = "1"
        //        sche.userID = "1111"
        //        sche.price = 1000
        //        sche.rep = 1
        //        sche.colorTag = "dark_blue"
        //        sche.tag = 1
        //        sche.type = "reserve"
        //        let schedule = Schedule.allObjects()
        //        schedualArray.append(sche)
        let sche = Schedule.allObjects()
        let users = User.allObjects()
        if sche.count > 0 {
            for i in 0...sche.count-1{
                self.schedualArray.append(sche[i] as! Schedule)
            }
        }
        if users.count > 0 {
            for i in 0...users.count-1{
                self.userArray[users[i].valueForKey("id") as! String] = users[i] as! User
            }
        }
        print(schedualArray)
        self.genScheduleOnTable()
        if schedualArray.count > 0 {
            self.tag = schedualArray[schedualArray.count-1].tag
        }
        self.view.bringSubviewToFront(vw_tab)
    }
    func genScheduleOnTable(){
        let h : CGFloat = CGFloat(((1.595*self.view.frame.height)/2)/17)
        let width = (self.view.frame.width)/CGFloat(field_num+1)
        if schedualArray.count > 0 {
            for i in 0...self.schedualArray.count-1{
                if schedualArray[i].date == self.label_date.text! {
                    var a : String = self.schedualArray[i].time
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
                    if Int(startMin) == 30 {
                        startMin = "0.5"
                    }else{
                        startMin = "0"
                    }
                    if Int(endMin) == 30 {
                        endMin = "0.5"
                    }else{
                        endMin = "0"
                    }
                    if Double(startMin) == 0.5 && Double(endMin) == 0.5 {
                        endMin = "0.5"
                    }
                    let view = UIView(frame: CGRectMake(CGFloat(Int(self.schedualArray[i].field)!)*width,((CGFloat(Int(startHour)!)-CGFloat(4))*h)+CGFloat(7)+CGFloat(Double(startMin)!)*h,width,((CGFloat(Int(endHour)!)-CGFloat(Int(startHour)!)-CGFloat(Double(startMin)!))*h)+CGFloat(Double(endMin)!)*h))
                    view.backgroundColor = self.tableColor.valueForKey(self.schedualArray[i].colorTag)! as! UIColor
                    self.keepTag.append(self.schedualArray[i].tag)
                    view.tag = self.schedualArray[i].tag
                    self.view.addSubview(view)
                    let lb = UILabel(frame:CGRectMake(0,0,width,view.frame.height/2))
                    lb.text = (self.userArray[schedualArray[i].userID]?.nickName)!
                    lb.textColor = UIColor.whiteColor()
                    lb.font = UIFont(name: "ThaiSansLite", size: 13)
                    lb.textAlignment = .Center
                    view.addSubview(lb)
                    let lb1 = UILabel(frame: CGRectMake(0,view.frame.height/2,width,view.frame.height/2))
                    lb1.text = (self.userArray[schedualArray[i].userID]?.contact)!
                    lb1.textColor = UIColor.whiteColor()
                    lb1.font = UIFont(name:"ThaiSansLite", size: 13)
                    lb1.textAlignment = .Center
                    view.addSubview(lb1)
                    self.view.bringSubviewToFront(vw_tab)
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
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if enable_touch {
            self.trigger_tab()
            enable_touch = !enable_touch
            return true
        }else{
            return false
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        //print(touch.locationInView(self.view))
        //f = UIView(frame: CGRectMake(touch.locationInView(self.view).x, touch.locationInView(self.view).y, 20, 20))
        self.x = touch.locationInView(self.view).x
        self.y = touch.locationInView(self.view).y
        if tab_trigger {
            x = touch.locationInView(self.view).x
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
    func drag(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .Changed :
            if enable_create_table{
                let transition = gesture.translationInView(self.view)
                //        print("x "+String(transition.x)+" "+String(self.x))
                //        print("y "+String(transition.y)+" "+String(self.y))
                let h : CGFloat = CGFloat(((1.595*self.view.frame.height)/2)/17)
                var height : Int = Int(transition.y/h)
                if transition.y % h != 0 {
                    height += 1
                }
                let width = (self.view.frame.width)/CGFloat(field_num+1)
                let tempx : Int = Int(self.x/width) //x position
                let tempy : Int = Int(self.y/h) // y position
                //            print(height)
                let first = (tempy-4)+(16*(tempx-1))
                let second = ((tempy-4)+(height-1))+(16*(tempx-1))
                if hh < transition.y{
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
                        for i in begin...self.tag{
                            if let tag = self.view.viewWithTag(i) {
                                tag.removeFromSuperview()
                            }
                        }
                        self.tag = self.schedualArray[schedualArray.count-1].tag
                    }
                }
                }
                if hh > transition.y{
                    drag_top = true
                    //print(tag)
                    if let tag = self.view.viewWithTag(self.tag) {
                        tag.removeFromSuperview()
                    }
                }
                if enable_create_table && hh < transition.y{
                drag_top = false
                f = UIView(frame: CGRectMake((CGFloat(tempx)*width),CGFloat(tempy)*h+CGFloat(7),width,(CGFloat(height)*h)))
                f.layer.borderWidth = 1
                f.layer.borderColor = UIColor(red: 225/255, green: 224/255, blue: 225/255, alpha: 1.0).CGColor
                f.backgroundColor = UIColor(red:232/255,green:81/255,blue:83/255,alpha:1.0)
                f.tag = self.tag+1
                print(self.tag+1)
                self.tag+=1
                self.view.addSubview(f)
                self.hh = transition.y
                self.field = String(tempx)
                self.time = String(tempy+4)+".00"+" - "+String(tempy+height+4)+".00"
                }
            }
        case .Ended :
            if enable_create_table && !drag_top{
                enable_create_table = false
                performSegueWithIdentifier("addTable", sender: self)
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
            let v = UIView(frame: CGRectMake((width*CGFloat(i))+(width), 0, 1, self.view.frame.height))
            v.backgroundColor = UIColor(red: 225/255, green: 224/255, blue: 225/255, alpha: 1.0)
            let label = UILabel(frame:CGRectMake((width*CGFloat(i))+(width)+(width/2)-6,self.view.frame.height*CGFloat(0.15),20,20))
            label.text = String(i+1)
            label.font = UIFont(name: "ThaiSansLite", size: 15)
            label.textColor = UIColor.blackColor()
            self.view.addSubview(label)
            self.view.addSubview(v)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTable" {
            if let des = segue.destinationViewController as? AddTableViewController {
                des.field = self.field
                let format = NSDateFormatter()
                format.dateStyle = NSDateFormatterStyle.FullStyle
                des.date = format.dateFromString(self.label_date.text!)!
                des.time = self.time
                des.price = "1000 บาท"
                des.rep = "1 สัปดาห์"
            }
        }
    }
    func genSlot(){
        slot = [String?](count:self.field_num*16, repeatedValue: nil)
        for i in 0...slot.count-1{
            slot[i] = "free"
        }
        if schedualArray.count > 0 {
            for i in 0...schedualArray.count-1 {
                if schedualArray[i].date == self.label_date.text! {
                    var a : String = self.schedualArray[i].time
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
                    let first = ((Int(startHour)!-8)+(16*(Int(schedualArray[i].field)!-1)))
                    let second = (Int(endHour)!-9)+(16*(Int(schedualArray[i].field)!-1))
                    for j in first...second {
                        slot[j] = schedualArray[i].id
                    }
                }
            }
        }
    }
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        if scrollView.viewWithTag(1) != nil {
    //        let scroll1 = scrollView.viewWithTag(1) as! UIScrollView
    //        print("y "+String(scroll1.contentOffset.y))
    //        print("x "+String(scroll1.contentOffset.x))
    //        }
    //        if scrollView.contentOffset.y >= 140{
    //            cons_top_view.constant = scrollView.contentOffset.y+20
    //            changeHeight = cons_top_view.constant
    //        }else{
    //            cons_top_view.constant = 160
    //        }
    //        if scrollView.contentOffset.x > 0 && changeHeight != nil{
    //            cons_top_view.constant = changeHeight
    //        }
    ////        if scrollView.contentOffset.x == 0 && changeHeight != nil {
    ////            cons_top_view.constant = changeHeight
    ////        }
    //
    //    }
    //    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    //        return UIInterfaceOrientationMask.Landscape
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
