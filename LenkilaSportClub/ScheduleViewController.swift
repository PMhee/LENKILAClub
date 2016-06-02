//
//  ScheduleViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    //    @IBOutlet weak var view_time: UIView!
    //    @IBOutlet weak var scrollView_table: UIScrollView!
    //    @IBOutlet weak var scrollView_page: UIScrollView!
    //    @IBOutlet weak var cons_top_view: NSLayoutConstraint!
    //    @IBOutlet weak var cons_lead_view: NSLayoutConstraint!
    //    var changeHeight : CGFloat!
    //    var changeWidth: CGFloat!
    @IBOutlet weak var label_date: UILabel!
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
