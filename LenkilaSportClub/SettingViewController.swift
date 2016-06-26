//
//  SettingViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/22/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var vw_tab: UIView!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var cons_vw_width: NSLayoutConstraint!
    var x :CGFloat = 0
    var y :CGFloat = 0
    var enable_touch : Bool = false
    var tab_trigger : Bool = false
    var settingLabel =  [["ซื้อแพ็คเกจ","ใส่คูปอง","ติดต่อฝ่ายขาย"]
                        ,["ข้อมูลส่วนตัว","แก้ไขสนาม","เปลี่ยนรหัสผ่าน"]
                        ,["แก้ไขขนาดตัวอักษร","การแจ้งเตือน","เปลี่ยนภาษา"]
                        ,["คู่มือการใช้งาน","คำถามที่พบบ่อย","ติดต่อเรา"]]

    @IBAction func btn_tab_action(sender: UIButton) {
        trigger_tab()
    }
    func trigger_tab(){
        var count = 0.0
        if !tab_trigger{
            //self.UserDetailTableView.userInteractionEnabled = false
            while(count <= 0.25){
                delay(count){
                    self.cons_vw_width.constant += self.view.frame.width/13
                }
                count += 0.025
            }
        }else{
            //self.UserDetailTableView.userInteractionEnabled = true
            while(count <= 0.25){
                delay(count){
                    self.cons_vw_width.constant -= self.view.frame.width/13
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //SettingHamburger
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 20, 20) //won't work if you don't set frame
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.addTarget(self, action: Selector("fbButtonPressed"), forControlEvents: .TouchUpInside)
        //let barButton = UIBarButtonItem()
        menuButton.customView = button
        //self.navigationItem.leftBarButtonItem = barButton 
        self.tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Lenkila Shop"
        } else if section == 2 {
            return "Profile"
        } else if section == 3 {
            return "General"
        } else {
            return "Help & Support"
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("row", forIndexPath: indexPath) as! SettingTableViewCell
        cell.label.font = UIFont(name: "ThaiSansLite",size: 24)
        cell.label.text = self.settingLabel[indexPath.section][indexPath.row]
        cell.icon.frame = CGRectMake(0, 0, 64, 64)
        cell.icon.image = UIImage(named: "settingIcon" + String(indexPath.section) + String(indexPath.row))
        
        cell.icon.contentMode = .ScaleAspectFit
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 2){
            if(indexPath.row == 2){
                let alertController = UIAlertController(title: "ขออภัย", message: "ระบบการเปลี่ยนภาษายังอยู่ในระหว่างการพัฒนา และจะถูกเพิ่มในเวอร์ชันถัดไป", preferredStyle: .Alert)
                let doneAction = UIAlertAction(title: "รับทราบ", style: .Default, handler: nil)
                alertController.addAction(doneAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }else{
            if(indexPath.row == 2){
                self.performSegueWithIdentifier("contactUs", sender: self)
            }
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
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


}
