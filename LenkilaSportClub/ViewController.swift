
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
    
    
    @IBAction func request_code_action(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Confirm Action", message: nil, preferredStyle: .actionSheet)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: "tel://0992850130")!)
        }
        let callAction = UIAlertAction(title: "Call 0992850130", style: .default, handler:callActionHandler)
        alertController.addAction(callAction)
        
        let copyActionHandler = { (action:UIAlertAction!) -> Void in
            UIPasteboard.general.string = "0992850130"
        }
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler:copyActionHandler)
        alertController.addAction(copyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var username_textfield: UITextField!
    @IBOutlet weak var cons_verticle: NSLayoutConstraint!
    @IBOutlet weak var user_name_placeholder: UILabel!
    @IBOutlet weak var tf_username: UITextField!
    
    @IBAction func sign_in_action(_ sender: UIButton) {
        var json = NSDictionary()
        let setting = Setting.allObjects()
        Alamofire.request(.POST, "http://128.199.227.19/Staff/login/"+tf_username.text!+"&"+username_textfield.text!)
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
            if json.value(forKey: "auth") == nil{
                self.delay(2){
                    if json.value(forKey: "auth") == nil{
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
                            let realm = RLMRealm.default()
                            realm.beginWriteTransaction()
                            var s = Setting()
                            s = setting[0] as! Setting
                            s.already_login = true
                            s.sportClub_id = (json.value(forKey: "sportClubID") as! NSNumber).stringValue
                            s.staff_id = (json.value(forKey: "staffID") as! NSNumber).stringValue
                            try! realm.commitWriteTransaction()
                        }
                        self.performSegue(withIdentifier: "signIn", sender: self)
                    }
                }
            }else if json.value(forKey: "auth")! as! String == "true"{
                if setting.count > 0 {
                    let realm = RLMRealm.default()
                    realm.beginWriteTransaction()
                    var s = Setting()
                    s = setting[0] as! Setting
                    s.already_login = true
                    s.sportClub_id = (json.value(forKey: "sportClubID") as! NSNumber).stringValue
                    s.staff_id = (json.value(forKey: "staffID") as! NSNumber).stringValue
                    try! realm.commitWriteTransaction()
                }
                self.performSegue(withIdentifier: "signIn", sender: self)
            }else if json.value(forKey: "auth")! as! String == "false"{
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
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            let s = Setting()
            s.already_login = false
            s.num_field = 0
            s.sche_time_stamp = "2014-08-05%2013:34:25"
            s.user_time_stamp = "2014-08-05%2013:34:25"
            s.language = "th"
            s.sche_inc_id = 0
            s.user_inc_id = 0
            realm.add(s)
            let p = Promotion()
            p.promotion_name = "ปกติ"
            p.promotion_type = "price"
            p.promotion_discount_price = 0.0
            realm.add(p)
            try! realm.commitWriteTransaction()
        }
        username_textfield.delegate = self
        tf_username.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let setting = Setting.allObjects()
        let s = setting[0] as! Setting
        //performSegueWithIdentifier("signIn", sender: self)
        if s.already_login{
            performSegue(withIdentifier: "signIn", sender: self)
        }
        
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tf_user_begin(_ sender: UITextField) {
        user_name_placeholder.text = ""
    }
    @IBAction func tf_pass_begin(_ sender: UITextField) {
        placeholder.text = ""
    }
    @IBAction func tf_user_end(_ sender: UITextField) {
        if tf_username.text! == ""{
        user_name_placeholder.text = "username"
        }
    }
    @IBAction func tf_pass_end(_ sender: UITextField) {
        if username_textfield.text! == ""{
            placeholder.text = "password"
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string:"")
        textField.text = ""
        //cons_verticle.constant += 50
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //cons_verticle.constant -= 50
        if textField.text! == ""{
            placeholder.text = "password"
        }
        return true
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
}


