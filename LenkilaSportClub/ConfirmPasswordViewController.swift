//
//  ConfirmPasswordViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 7/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
class ConfirmPasswordViewController: UIViewController,UITextFieldDelegate {
    
    var newPassword = String()

    @IBAction func backText(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "editNewPassword", sender: self)
    }
    @IBAction func backIcon(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "editNewPassword", sender: self)
    }
    
    @IBOutlet var confirmPass: UITextField!
    @IBAction func save(_ sender: AnyObject) {
        if(confirmPass.text == newPassword){
            let realm = RLMRealm.default()
            realm.beginWriteTransaction()
            var setting = Setting()
            let set = Setting.allObjects()
            setting = set[0] as! Setting
            //setting.passCode = confirmPass.text!
            try! realm.commitWriteTransaction()
            self.performSegue(withIdentifier: "savePassword", sender: self)
        }else{
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.showError("ผิดพลาด", subTitle: "รหัสผ่านไม่ครงกัน กรุณากรอกใหม่อีกครั้ง")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmPass.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
