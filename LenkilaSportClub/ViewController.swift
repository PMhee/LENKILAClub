
//  ViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import SCLAlertView
import Realm
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
    
    @IBAction func sign_in_action(sender: UIButton) {
        let setting = Setting.allObjects()
        if setting.count > 0 {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            var s = Setting()
            s = setting[0] as! Setting
            s.already_login = true
            try! realm.commitWriteTransaction()
        }
        if username_textfield.text! == (setting[0] as! Setting).passCode{
        performSegueWithIdentifier("signIn", sender: self)
        }else{
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.showError("Error", subTitle: "The code does not exist please contact us")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let setting = Setting.allObjects()
        print(setting.count)
        if setting.count == 0 {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            let s = Setting()
            s.passCode = "Geeksquadconsulting"
            s.already_login = false
            s.num_field = 0
            realm.addObject(s)
            try! realm.commitWriteTransaction()
        }
                username_textfield.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let setting = Setting.allObjects()
        let s = setting[0] as! Setting
        if s.already_login{
            performSegueWithIdentifier("signIn", sender: self)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string:"")
        textField.text = ""
        placeholder.text = ""
        cons_verticle.constant += 50
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cons_verticle.constant -= 50
        if textField.text! == ""{
            placeholder.text = "Enter Code"
        }
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
}


