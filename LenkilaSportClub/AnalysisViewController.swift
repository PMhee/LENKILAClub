//
//  AnalysisViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/25/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController,UIGestureRecognizerDelegate {

    var x :CGFloat = 0
    var y :CGFloat = 0
    var enable_touch : Bool = false
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    @IBOutlet weak var cons_tab_width: NSLayoutConstraint!
    var tab_trigger : Bool = false
    @IBAction func btn_tab_action(sender: UIButton) {
        trigger_tab()
    }
    @IBOutlet weak var vw_show_money: UIView!
    @IBOutlet weak var vw_show_reserve: UIView!
    @IBOutlet weak var vw_show_graph: UIView!
    
    
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
                    self.cons_tab_width.constant += self.view.frame.width/13
                }
                count += 0.025
            }
        }else{
            //self.UserDetailTableView.userInteractionEnabled = true
            while(count <= 0.25){
                delay(count){
                    self.cons_tab_width.constant -= self.view.frame.width/13
                }
                count += 0.025
            }
            
        }
        tab_trigger = !tab_trigger
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
        vw_show_money.layer.cornerRadius = 5
        vw_show_money.layer.borderWidth = 2
        vw_show_money.layer.borderColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0).CGColor
        vw_show_reserve.layer.cornerRadius = 5
        vw_show_reserve.layer.borderWidth = 2
        vw_show_reserve.layer.borderColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0).CGColor
        vw_show_graph.layer.cornerRadius = 5
        vw_show_graph.layer.borderWidth = 2
        vw_show_graph.layer.borderColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0).CGColor
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
