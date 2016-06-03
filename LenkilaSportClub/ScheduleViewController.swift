//
//  ScheduleViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
class ScheduleViewController: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    //    @IBOutlet weak var view_time: UIView!
    //    @IBOutlet weak var scrollView_table: UIScrollView!
    //    @IBOutlet weak var scrollView_page: UIScrollView!
    //    @IBOutlet weak var cons_top_view: NSLayoutConstraint!
    //    @IBOutlet weak var cons_lead_view: NSLayoutConstraint!
    //    var changeHeight : CGFloat!
    //    var changeWidth: CGFloat!
    @IBOutlet weak var label_date: UILabel!
    var schedualArray = [Schedule]()
    let tableColor : NSDictionary = ["green":UIColor(red:122/255,green:190/255,blue:139/255,alpha:1.0),"gray":UIColor(red:122/255,green:118/255,blue:119/255,alpha:1.0),"dark_blue":UIColor(red:84/255,green:110/255,blue:122/255,alpha:1.0),"blue":UIColor(red:16/255,green:118/255,blue:152/255,alpha:1.0),"yellow":UIColor(red:252/255,green:221/255,blue:121/255,alpha:1.0),"orange":UIColor(red:231/255,green:158/255,blue:63/255,alpha:1.0),"pink":UIColor(red:205/255,green:122/255,blue:121/255,alpha:1.0),"red":UIColor(red:232/255,green:81/255,blue:83/255,alpha:1.0)]
    var f = UIView!()
    var x = CGFloat!()
    var y = CGFloat!()
    let field_num = 4
    var hh  = 0
    var field : String!
    var date : String!
    var time : String!
    var name : String!
    var price : String!
    var rep : String!
    var today = NSDate()
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBAction func tap_gesture(sender: UITapGestureRecognizer){
    }
    @IBAction func btn_left_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        label_date.text = format.stringFromDate(today.dateByAddingTimeInterval(-60*60*24))
        today = today.dateByAddingTimeInterval(-60*60*24)
    }
    @IBAction func btn_right_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        label_date.text = format.stringFromDate(today.dateByAddingTimeInterval(60*60*24))
        today = today.dateByAddingTimeInterval(60*60*24)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.delegate = self
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ScheduleViewController.drag(_:)))
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(tapGesture)
        self.genTableField()
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        label_date.text = format.stringFromDate(NSDate())
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let realm = RLMRealm.defaultRealm()
        let user = User()
        user.age = 22
        user.contact = "0992850130"
        let format = NSDateFormatter()
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        user.freqPlay = format.stringFromDate(NSDate())
        user.gender = "ชาย"
        user.id = "1111"
        user.name = "ธนากร รัตนจริยา"
        user.nickName = "นนท์"
        user.playCount = 4
        user.price = 1000
        user.workPlace = "Lenkila"
        let sche = Schedule()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        sche.date = format.stringFromDate(NSDate())
        sche.time = "12.30 - 14.00"
        sche.field = "1"
        sche.userID = "1111"
        sche.id = "1111"
        sche.price = 1000
        sche.rep = 1
        sche.tag = "dark_blue"
        sche.type = "reserve"
        let schedule = Schedule.allObjects()
        schedualArray.append(sche)
        print(schedualArray)
        self.genScheduleOnTable()
    }
    func genScheduleOnTable(){
        let h : CGFloat = CGFloat(((1.595*self.view.frame.height)/2)/17)
        let width = (self.view.frame.width)/CGFloat(field_num+1)
        for i in 0...self.schedualArray.count-1{
            let a : String = self.schedualArray[i].time
            var range: Range<String.Index> = a.rangeOfString(" ")!
            var index: Int = a.startIndex.distanceTo(range.startIndex)
            let startHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: a.startIndex.advancedBy(2)))
            var startMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(3), end: a.startIndex.advancedBy(5)))
            var endMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(11), end: (a.endIndex.advancedBy(0))))
            let endHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(8), end: a.startIndex.advancedBy(10)))
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
                endMin = "0"
            }
            if Double(startMin) == 0.5 && Double(endMin) == 0 {
                endMin = "-0.5"
            }
            let view = UIView(frame: CGRectMake(CGFloat(Int(self.schedualArray[i].field)!)*width,((CGFloat(Int(startHour)!)-CGFloat(4))*h)+CGFloat(7)+CGFloat(Double(startMin)!)*h,width,((CGFloat(Int(endHour)!)-CGFloat(Int(startHour)!))*h)+CGFloat(Double(endMin)!)*h))
            view.backgroundColor = self.tableColor.valueForKey(self.schedualArray[i].tag)! as! UIColor
            self.view.addSubview(view)
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        //print(touch.locationInView(self.view))
        //f = UIView(frame: CGRectMake(touch.locationInView(self.view).x, touch.locationInView(self.view).y, 20, 20))
        self.x = touch.locationInView(self.view).x
        self.y = touch.locationInView(self.view).y
        
        //f.backgroundColor = UIColor.blueColor()
        //self.view.addSubview(f)
        return true
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceivePress press: UIPress) -> Bool {
        //print(press)
        return true
    }
    func drag(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .Changed : let transition = gesture.translationInView(self.view)
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
        self.hh = height
        //            print(height)
        f = UIView(frame: CGRectMake((CGFloat(tempx)*width),CGFloat(tempy)*h+CGFloat(7),width,(CGFloat(height)*h)))
        f.layer.borderWidth = 1
        f.layer.borderColor = UIColor(red: 225/255, green: 224/255, blue: 225/255, alpha: 1.0).CGColor
        f.backgroundColor = UIColor(red:122/255,green:190/255,blue:139/255,alpha:1.0)
        self.view.addSubview(f)
        self.field = String(tempx)
        self.time = String(tempy+4)+".00"+" - "+String(tempy+height+4)+".00"
        case .Ended : performSegueWithIdentifier("addTable", sender: self)
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
            label.font = UIFont(name: "Helvetica Neue", size: 12)
            label.textColor = UIColor.blackColor()
            self.view.addSubview(label)
            self.view.addSubview(v)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTable" {
            if let des = segue.destinationViewController as? AddTableViewController {
                    des.field = self.field
                    des.date = self.today
                    des.time = self.time
                    des.price = "1000 บาท"
                    des.rep = "1 สัปดาห์"
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
