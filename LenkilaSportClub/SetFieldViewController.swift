//
//  SetFieldViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 7/24/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
class SetFieldViewController: UIViewController,UITextFieldDelegate {

    @IBAction func btn_confirm(sender: UIButton) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        let setting = Setting.allObjects()
        let s = setting[0] as! Setting
        if Int(tf_num_field.text!) != nil {
            s.num_field = Int(self.tf_num_field.text!)!
            self.performSegueWithIdentifier("edit_done", sender: self)
        }else{
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.showError("ผิดพลาด", subTitle: "กรุณาใส่ตัวเลขเท่านั้น")
        }
        try! realm.commitWriteTransaction()
    }
    @IBOutlet weak var tf_num_field: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_num_field.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
