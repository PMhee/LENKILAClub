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
    
    
    @IBOutlet weak var cons_vw_width: NSLayoutConstraint!
    var x :CGFloat = 0
    var y :CGFloat = 0
    var enable_touch : Bool = false
    var tab_trigger : Bool = false
    var settingLabel =  [["ข้อมูลส่วนตัว","โปรโมชั่น","เปลี่ยนรหัสผ่าน"]
                        ,["แก้ไขขนาดตัวอักษร","เปลี่ยนภาษา"]
                        ,["คู่มือการใช้งาน","คำถามที่พบบ่อยและแจ้งปัญหา","ติดต่อเรา"]]

    @IBAction func btn_tab_action(_ sender: UIButton) {
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
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //SettingHamburger
//        let button = UIButton()
//        button.frame = CGRectMake(0, 0, 20, 20) //won't work if you don't set frame
//        button.setImage(UIImage(named: "menu"), forState: .Normal)
//        button.addTarget(self, action: Selector("fbButtonPressed"), forControlEvents: .TouchUpInside)
//        //let barButton = UIBarButtonItem()
//        menuButton.customView = button
//        //self.navigationItem.leftBarButtonItem = barButton 
        self.tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 2
        }else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Profile"
        } else if section == 1 {
            return "General"
        } else {
            return "Help & Support"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! SettingTableViewCell
        cell.label.font = UIFont(name: "ThaiSansLite",size: 24)
        cell.label.text = self.settingLabel[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        cell.icon.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        cell.icon.image = UIImage(named: "settingIcon" + String((indexPath as NSIndexPath).section) + String((indexPath as NSIndexPath).row))
        
        cell.icon.contentMode = .scaleAspectFit
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).section == 0){
            if((indexPath as NSIndexPath).row == 0){
                let alertController = UIAlertController(title: "ขออภัย", message: "ระบบการแก้ไขข้อมูลส่วนตัวยังอยู่ในระหว่างการพัฒนา และจะถูกเพิ่มในเวอร์ชันถัดไป", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "รับทราบ", style: .default, handler: nil)
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
                //self.performSegueWithIdentifier("profile", sender: self)
            }else if((indexPath as NSIndexPath).row == 1){
//                let alertController = UIAlertController(title: "ขออภัย", message: "ระบบการแก้ไขสนามยังอยู่ในระหว่างการพัฒนา และจะถูกเพิ่มในเวอร์ชันถัดไป", preferredStyle: .Alert)
//                let doneAction = UIAlertAction(title: "รับทราบ", style: .Default, handler: nil)
//                alertController.addAction(doneAction)
            //self.presentViewController(alertController, animated: true, completion: nil)
                self.performSegue(withIdentifier: "editField", sender: self)
            }else{
                self.performSegue(withIdentifier: "changePassword", sender: self)
            }
        }else if((indexPath as NSIndexPath).section == 1){
            if((indexPath as NSIndexPath).row == 0){
                let alertController = UIAlertController(title: "ขออภัย", message: "ระบบการเปลี่ยนขนาดตัวอักษรยังอยู่ในระหว่างการพัฒนา และจะถูกเพิ่มในเวอร์ชันถัดไป", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "รับทราบ", style: .default, handler: nil)
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
            
            }else{
                let alertController = UIAlertController(title: "ขออภัย", message: "ระบบการเปลี่ยนภาษายังอยู่ในระหว่างการพัฒนา และจะถูกเพิ่มในเวอร์ชันถัดไป", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "รับทราบ", style: .default, handler: nil)
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }else{
            if((indexPath as NSIndexPath).row == 0){
                let alertController = UIAlertController(title: "ขออภัย", message: "คู่มือการใช้งานยังอยู่ในระหว่างการพัฒนา และจะถูกเพิ่มในเวอร์ชันถัดไป", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "รับทราบ", style: .default, handler: nil)
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
                //self.performSegueWithIdentifier("tutorial", sender: self)
            }else if((indexPath as NSIndexPath).row == 1){
                self.performSegue(withIdentifier: "faq", sender: self)
            }else{
                self.performSegue(withIdentifier: "contactUs", sender: self)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
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


}
