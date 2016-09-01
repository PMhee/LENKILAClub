
//  ViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import SCLAlertView
import Realm
import Alamofire
class ViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBAction func request_code_action(sender: UIButton) {
        let alertController = UIAlertController(title: "Confirm Action", message: nil, preferredStyle: .ActionSheet)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://0992850130")!)
        }
        let callAction = UIAlertAction(title: "Call 0992850130", style: .Default, handler:callActionHandler)
        alertController.addAction(callAction)
        
        let copyActionHandler = { (action:UIAlertAction!) -> Void in
            UIPasteboard.generalPasteboard().string = "0992850130"
        }
        let copyAction = UIAlertAction(title: "Copy", style: .Default, handler:copyActionHandler)
        alertController.addAction(copyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var username_textfield: UITextField!
    @IBOutlet weak var cons_verticle: NSLayoutConstraint!
    @IBOutlet weak var user_name_placeholder: UILabel!
    @IBOutlet weak var tf_username: UITextField!
    
    @IBAction func sign_in_action(sender: UIButton) {
        var json = NSDictionary()
        let setting = Setting.allObjects()
        Alamofire.request(.POST, "http://192.168.1.48:8000/Staff/login/"+tf_username.text!+"&"+username_textfield.text!)
            .validate()
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
            }
            .responseJSON { response in
                debugPrint(response.result.value)
                if response.result.value == nil {
                    
                }else{
                    json = response.result.value as! NSDictionary
                }
        }
        delay(2){
            if json.valueForKey("auth") == nil{
                self.delay(2){
                    if json.valueForKey("auth") == nil{
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                            kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                            kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                            showCloseButton: true
                        )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.showError("ผิดพลาด", subTitle: "เชื่อมต่อล้มเหลว")
                    }else{
                        if setting.count > 0 {
                            let realm = RLMRealm.defaultRealm()
                            realm.beginWriteTransaction()
                            var s = Setting()
                            s = setting[0] as! Setting
                            s.already_login = true
                            s.sportClub_id = (json.valueForKey("sportClubID") as! NSNumber).stringValue
                            s.staff_id = (json.valueForKey("staffID") as! NSNumber).stringValue
                            try! realm.commitWriteTransaction()
                        }
                        self.performSegueWithIdentifier("signIn", sender: self)
                    }
                }
            }else if json.valueForKey("auth")! as! String == "true"{
                if setting.count > 0 {
                    let realm = RLMRealm.defaultRealm()
                    realm.beginWriteTransaction()
                    var s = Setting()
                    s = setting[0] as! Setting
                    s.already_login = true
                    s.sportClub_id = (json.valueForKey("sportClubID") as! NSNumber).stringValue
                    s.staff_id = (json.valueForKey("staffID") as! NSNumber).stringValue
                    try! realm.commitWriteTransaction()
                }
                self.performSegueWithIdentifier("signIn", sender: self)
            }else if json.valueForKey("auth")! as! String == "false"{
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                    showCloseButton: true
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.showError("ผิดพลาด", subTitle: "กรุณาระบุรหัสผ่านให้ถูกต้อง")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let setting = Setting.allObjects()
        if setting.count == 0 {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            let s = Setting()
            s.already_login = false
            s.num_field = 0
            s.time_stamp = "2014-08-05%2013:34:25"
            s.language = "th"
            realm.addObject(s)
            let p = Promotion()
            p.promotion_name = "ปกติ"
            p.promotion_type = "price"
            p.promotion_discount_price = 0.0
            realm.addObject(p)
            try! realm.commitWriteTransaction()
        }
        username_textfield.delegate = self
        tf_username.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let setting = Setting.allObjects()
        let s = setting[0] as! Setting
        //performSegueWithIdentifier("signIn", sender: self)
        if s.already_login{
            performSegueWithIdentifier("signIn", sender: self)
        }
        
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tf_user_begin(sender: UITextField) {
        user_name_placeholder.text = ""
    }
    @IBAction func tf_pass_begin(sender: UITextField) {
        placeholder.text = ""
    }
    @IBAction func tf_user_end(sender: UITextField) {
        if tf_username.text! == ""{
        user_name_placeholder.text = "username"
        }
    }
    @IBAction func tf_pass_end(sender: UITextField) {
        if username_textfield.text! == ""{
            placeholder.text = "password"
        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string:"")
        textField.text = ""
        //cons_verticle.constant += 50
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //cons_verticle.constant -= 50
        if textField.text! == ""{
            placeholder.text = "password"
        }
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
}


